
import Foundation
import OSLog

/// Стандартная реализация логгера для обработки событий типа `NetworkableEvent`
public final class NetworkableLogger: Eventable {
    
    private var serviceIdentifier: String?
    
    private let systemLogsEnabled: Bool
    private let completion: LoggerCompletion
    
    public init(systemLogsEnabled: Bool, completion: @escaping LoggerCompletion = { _ in }) {
        self.systemLogsEnabled = systemLogsEnabled
        self.completion = completion
    }
    
    public func handle(event: NetworkEvent) {
        switch event {
        case .initial(let serviceId):
            if serviceIdentifier == nil {
                serviceIdentifier = serviceId
            }
            log(message: "\(serviceId) has been initialized")
        case .request(let request):
            log(message: request.rawValue)
            log(message: request.cURL)
        case .response(let response):
            log(message: response.data.prettyJSON)
            log(message: response.response.description)
        case .error(let error):
            log(error: error)
        case .custom(let message):
            log(message: message)
        }
    }
}

private extension NetworkableLogger {
    func log(type: OSLogType, message: LogMessage) {
        consoleLog(type: type, message: message)
        printLog(message: message)
        completion(message)
    }
    
    func log(message: LogMessage) {
        consoleLog(type: .debug, message: message)
        printLog(message: message)
        completion(message)
    }
    
    func log(error: NetworkError) {
        consoleLog(type: .error, message: error.description)
        printLog(message: error.description)
        completion(error.description)
    }
}

private extension NetworkableLogger {
    func printLog(message: LogMessage) {
        let date = Date().formatted(date: .abbreviated, time: .standard)
        print("[\(date)] \(serviceIdentifier ?? ""):\n\(message)")
    }
    
    func consoleLog(type: OSLogType, message: LogMessage) {
        guard systemLogsEnabled else { return }
        os_log(type, "### %{public}@", "\(serviceIdentifier ?? "") \(message)")
    }
}
