
import Foundation

/// Данный тип отображает методы для отправки HTTP-запроса
public enum RequestMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}
