import Foundation

/// Тип данных, отражающий возможные ошибки, которые может поймать  AsyncNetwork
public enum NetworkError: Swift.Error {
    /// Указывает на невозможность кодировки данных внутри структуры Endpoint
    case encode(Swift.Error)
    
    /// Указывает на невозможность декодировать объект
    case decode(Swift.Error?)
    
    /// Указывает на неверно составленный URL
    case invalidUrl(RequestEndpoint)
    
    /// Указывает на невозможность доставки запроса (как правило, по причине отсутствия ответа от сервера)
    case transport(RequestEndpoint)
    
    /// Указывает на то, что выполнение данного запроса было отменено
    case cancelled(RequestEndpoint)
    
    /// Отражает код ошибки
    case unexpectedStatusCode(response: EventableResponse)
    
    /// Указывает на неудачную попытку рефреша
    case invalidCredentials
}

extension NetworkError {
    /// Текстовое описание ошибки
    public var description: String {
        switch self {
        case .encode(let error):
            "Request encoding was failed\n\(error.localizedDescription)"
        case .decode(let error):
            "Can't decode\n\(error?.localizedDescription ?? "")"
        case .invalidUrl(let endpoint):
            "Invalid url for endpoint \(endpoint.host + endpoint.path)"
        case .transport:
            "Request failed"
        case .cancelled:
            "Task was cancelled"
        case .unexpectedStatusCode(let response):
            "Request error\n\(response)"
        case .invalidCredentials:
            "Refresh's task has been failed"

        }
    }
}

extension NetworkError: Equatable {
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (let l, let r):
            l.description == r.description
        }
    }
}
