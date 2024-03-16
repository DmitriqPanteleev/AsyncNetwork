
import Foundation

/// Тип данных для отправки запроса типа "multipart/form-data"
public struct MultipartFormData {
    /// Уникальный разделитель для построения запроса (по-умолчанию используется `UUID`)
    public let boundary: String
    
    /// Составляющие части запроса
    public let fields: [MultipartFormField]
    
    public init(boundary: String = UUID().uuidString, fields: [MultipartFormField]) {
        self.boundary = boundary
        self.fields = fields
    }
}

/// Тип данных для сборки запроса типа "multipart/form-data"
public struct MultipartFormField {
    /// Название поля
    public let name: String
    
    /// Тип информации, которую будет передавать данное поле
    public let type: Option
    
    public init(name: String, value: String) {
        self.name = name
        self.type = .value(value)
    }
    
    public init(name: String, data: Data, fileName: String, mimeType: MimeType) {
        self.name = name
        self.type = .data(data, fileName: fileName, mimeType: mimeType)
    }
}

extension MultipartFormField {
    /// Тип поля для сборки запроса типа "multipart/form-data"
    ///
    /// Поле может передавать в себе либо информацию в строке, либо данные (например, изображение)
    public enum Option {
        /// Передача данных в запросе типа "multipart/form-data"
        ///
        /// Для корректной передачи данных необходимо указать название файла и его MIME-тип
        ///
        /// MIME-тип - Специальная текстовая метка, которая прикрепляется к передаваемому по протоколу HTTP объекту и описывает тип этого объекта
        case data(Data, fileName: String, mimeType: MimeType)
        
        /// Передача строки в запросе типа "multipart/form-data"
        case value(String)
    }
}
