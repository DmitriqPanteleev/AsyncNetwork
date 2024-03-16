
import Foundation

extension Data {
    /// Метод для декодирования данных для любого типа, подписанного на протокол `Decodable`
    /// В случае неудачи будет возвращена ошибка `NetworkableError.decode`
    public func decode<T: Decodable>(to type: T.Type) throws -> T {
        do {
            return try JSONDecoder().decode(type, from: self)
        } catch {
            throw NetworkableError.decode(error)
        }
    }
    
    /// Метод для декодирования данных для любого вложенного в JSON типа, подписанного на протокол `Decodable`
    /// В случае неудачи будет возвращена ошибка `NetworkableError.decode`
    public func decode<T: Decodable>(to type: T.Type, at keyPath: String) throws -> T {
        do {
            guard let json = try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any],
                  let object = json[keyPath],
                  JSONSerialization.isValidJSONObject(object) else { throw NetworkableError.decode(nil) }
            
            let data = try JSONSerialization.data(withJSONObject: object)
            
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkableError.decode(error)
        }
    }
    
    /// Метод для декодирования строки
    /// В случае неудачи будет возвращена ошибка `NetworkableError.decode`
    public func decodeString(for keyPath: String) throws -> String {
        do {
            guard let json = try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any],
                  let value = json[keyPath] as? String else { throw NetworkableError.decode(nil) }
            return value
        } catch {
            throw NetworkableError.decode(error)
        }
    }
}

extension Data {
    /// Метод для печати в консоль
    public var prettyJSON: String {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return responseString }
        
        return String(prettyPrintedString)
    }
    
    var responseString: String {
        String(data: self, encoding: .utf8) ?? "Have no data in response"
    }
}
