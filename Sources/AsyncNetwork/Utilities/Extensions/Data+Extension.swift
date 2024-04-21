
import Foundation

extension Data {
    /// Метод для декодирования данных для любого типа, подписанного на протокол `Decodable`
    /// В случае неудачи будет возвращена ошибка `NetworkableError.decode`
    public func decode<T: Decodable>(to type: T.Type) throws -> T {
        do {
            return try JSONDecoder().decode(type, from: self)
        } catch {
            throw NetworkError.decode(error)
        }
    }
    
    /// Метод для декодирования данных для любого вложенного в JSON типа, подписанного на протокол `Decodable`
    /// В случае неудачи будет возвращена ошибка `NetworkableError.decode`
    public func decode<T: Decodable>(to type: T.Type, at keyPath: String) throws -> T {
        do {
            guard let json = try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any],
                  let object = json[keyPath],
                  JSONSerialization.isValidJSONObject(object) else { throw NetworkError.decode(nil) }
            
            let data = try JSONSerialization.data(withJSONObject: object)
            
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decode(error)
        }
    }
    
    /// Метод для декодирования строки
    /// В случае неудачи будет возвращена ошибка `NetworkableError.decode`
    public func decodeString(for keyPath: String) throws -> String {
        do {
            guard let json = try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any],
                  let value = json[keyPath] as? String else { throw NetworkError.decode(nil) }
            return value
        } catch {
            throw NetworkError.decode(error)
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

extension Data {
    static let mimeSignatures: [MimeSignature] = [
        // MARK: Images
        ([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A], "image/png"),
        ([0xFF, 0xD8, 0xFF, 0xDB, 0xE0, 0x4A, 0x46, 0x49, 0xE1, 0x45, 0x78, 0x69, 0x66], "image/jpeg"),
        ([0x47, 0x49, 0x46, 0x38, 0x37, 0x39, 0x61], "image/gif"),
        
        // MARK: Audio
        ([0xF2, 0xF3, 0xFB], "audio/mpeg"),
        
        // MARK: Video
        ([0x00, 0x01, 0xB3], "video/mpeg"),
        
        // MARK: Application
        ([0x25, 0x44, 0x2D], "application/pdf"),
        ([0x7B, 0x5C, 0x72, 0x74, 0x31], "application/rtf"),
        
        // MARK: Text
        ([0x3c, 0x3f, 0x78, 0x6d, 0x6c, 0x20], "text/xml")
    ]
    
    var mimeType: String {
        let tenFirstBytes = Array(subdata(in: 0..<10))
        
        let mimeSignature = Data.mimeSignatures.filter { signature in
            tenFirstBytes.starts(with: signature.0)
        }.first
        
        return mimeSignature?.1 ?? "application/octet-stream"
    }
}
