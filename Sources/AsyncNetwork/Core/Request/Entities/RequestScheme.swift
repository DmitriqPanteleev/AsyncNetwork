
import Foundation

/// Схема для отправки запроса
///
/// На текущий момент доступны следующие схемы:
///  - HTTPS (по-умолчанию)
///  - HTTP
public enum RequestScheme: String {
    /// Схема для отправки по HTTP
    ///
    /// Для отправки запросов по схеме HTTP не забудьте добавить в plist файл проекта
    /// словарь NSAppTransportSecurity и задать в нем атрибут NSAllowsArbitraryLoads со значением YES
    case http
    
    /// Схема для отправки по HTTPS
    case https
}
