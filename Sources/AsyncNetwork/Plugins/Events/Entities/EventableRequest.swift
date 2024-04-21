
import Foundation

/// Тип данных, отображающий HTTP-запрос и описанный к нему `RequestEndpoint`
public struct EventableRequest {
    /// Эндпоинт, на основе которого был отправлен запрос
    public let endpoint: RequestEndpoint
    
    /// Непосредственно сконструированный по эндпоинту запрос
    public let request: URLRequest
}

extension EventableRequest {
    /// Метод для приведения объекта к строке
    public var rawValue: String {
        request.description
    }
    
    /// Метод, конструирующий cURL из отправленного запроса
    public var cURL: String {
        request.cURL()
    }
}
