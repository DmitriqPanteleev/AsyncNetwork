import Foundation
import Combine

/// Основной сервис для отправки запросов.
///
/// Для отправки запроса используется метод
/// ```
/// func sendRequest(with endpoint: RequestEndpoint) async throws -> Data
/// ```
///
/// Для конфигурации сервиса используйте структуру данных `NetworkableConfiguration` и передайте ее в инициализатор.
///
/// Данный сервис также поддерживает систему обновления данных для авторизации. Чтобы подключить данную систему,
/// необходимо передать в иниициализатор параметр `refreshOptions`. По-умолчанию данный параметр равен `nil`,
/// что говорит о выключенном состоянии системы обновления данных для авторизации
public final class AsyncNetwork {
    // MARK: Internal
    private let session: URLSession
    private let formatter: RequestFormatter
    
    // MARK: External
    private let eventManager: EventManager?
    private let options: NetworkConfiguration
    
    // MARK: Refresh
    private var refresher: Refresher?
    private let refreshOptions: RefreshOptions?
    
    /// Стрим для получения данных из сервиса для рефреша
    ///
    /// Стрим, с помощью которого пользователь может получать все новые данные, полученные в результате обновления данных для авторизации.
    ///
    /// Данное свойство является опциональным, но если в сервис был передан параметр `refreshOptions`, то можно быть уверенным, что это свойство существует
    ///
    /// # Пример использования
    /// ```
    /// for await refresh in refreshStream! {
    ///     let token = refresh.decode(to: Token.self)
    ///     tokenManager.save(token)
    /// }
    /// ```
    public var refreshStream: RefreshStream?
    
    public init(options: NetworkConfiguration,
                refreshOptions: RefreshOptions? = nil,
                eventManager: EventManager? = nil)
    {
        self.session = URLSession.shared
        self.formatter = RequestFormatter()
        
        self.options = options
        
        self.eventManager = eventManager
        
        self.refreshOptions = refreshOptions
        setupRefresher()
        
        sendEventable()
    }
    
    
    /// Метод для отправки запросов в сеть
    ///
    /// Для отправки запроса нужно передать аргумент типа `RequestEndpoint`.
    ///
    /// Данный метод может вернуть либо ответ в форме `Data`, либо же ошибку типа `NetworkableError`
    public func sendRequest(with endpoint: RequestEndpoint) async throws -> Data {
        return try await loadRequest(endpoint: endpoint)
    }
}

extension AsyncNetwork {
    private func loadRequest(endpoint: RequestEndpoint, shouldRetry: Bool = true) async throws -> Data {
        let request = try formatter.build(from: endpoint,
                                          cachePolicy: options.cachePolicy,
                                          timeoutInterval: options.timeoutInterval,
                                          extraHeaders: options.extraHeaders)
        
        let response: SessionResponse = try await session.data(for: request)
        
        guard let httpResponse = response.1 as? HTTPURLResponse else {
            throw NetworkError.transport(endpoint)
        }
        
        let eventRequest = sendEventable(request: request, with: endpoint)
        let eventResponse = sendEventable(response: response, with: eventRequest, code: httpResponse.statusCode)
        
        guard httpResponse.statusCode != refreshOptions?.statusCode else {
            
            guard shouldRetry else {
                throw NetworkError.invalidCredentials
            }
            
            do {
                try await refresher?.refresh()
            } catch {
                throw NetworkError.invalidCredentials
            }
            
            return try await loadRequest(endpoint: endpoint, shouldRetry: false)
        }
        
        if StatusCodes.successCodes.contains(httpResponse.statusCode) {
            return response.0
        } else {
            throw NetworkError.unexpectedStatusCode(response: eventResponse)
        }
    }
}

extension AsyncNetwork {
    private func setupRefresher() {
        guard let refreshOptions = self.refreshOptions else { return }
        
        self.refreshStream = RefreshStream { continuation in
            self.refresher = Refresher(service: self,
                                       options: refreshOptions,
                                       continuation: continuation)
        }
    }
}

extension AsyncNetwork {
    func sendEventable() {
        eventManager?.notifyAll(with: .initial(options.identifier))
    }
    
    func sendEventable(request: URLRequest, with endpoint: RequestEndpoint) -> EventableRequest {
        let eventRequest = EventableRequest(endpoint: endpoint, request: request)
        eventManager?.notifyAll(with: .request(eventRequest))
        return eventRequest
    }

    func sendEventable(response: SessionResponse, with request: EventableRequest, code: StatusCode) -> EventableResponse {
        let eventResponse = EventableResponse(request: request, 
                                              response: response.1,
                                              data: response.0,
                                              statusCode: code)
        eventManager?.notifyAll(with: .response(eventResponse))
        return eventResponse
    }
}
