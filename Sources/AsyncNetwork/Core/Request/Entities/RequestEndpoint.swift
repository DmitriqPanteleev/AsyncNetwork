import Foundation

/// Контракт, который реализуют эндпоинты
///
/// С помощью данного протокола осуществляется подготовка и отправка HTTP-запросов
public protocol RequestEndpoint {
    /// Схема для URL запроса
    var scheme: RequestScheme { get }
    
    /// Хост для URL запроса
    var host: String { get }
    
    /// Путь запроса для каждого конкретного эндпоинта
    var path: String { get }
    
    /// Порт для URL запроса
    var port: Int? { get }
    
    /// HTTP-метод
    ///
    /// На текущий момент поддерживаются следующие методы:
    ///  - GET
    ///  - PUT
    ///  - POST
    ///  - PATCH
    ///  - DELETE
    var method: RequestMethod { get }
    
    /// Query-параметры для запроса для каждого конкретного запроса
    var query: RequestQuery? { get }
    
    /// Хэдеры для запроса
    var headers: RequestHeaders? { get }
    
    /// Тело запроса (приводится к строке)
    var body: DynamicDictionary? { get }
    
    /// Данные для отправки запроса типа "multipart/form-data"
    var fileData: MultipartFormData? { get }
}

public extension RequestEndpoint {
    var scheme: RequestScheme {
        .https
    }
    
    var port: Int? {
        nil
    }
    
    var query: RequestQuery? {
        nil
    }
    
    var fileData: MultipartFormData? {
        nil
    }
    
    var body: DynamicDictionary? {
        nil
    }
    
    var headers: RequestHeaders? {
        nil
    }
}
