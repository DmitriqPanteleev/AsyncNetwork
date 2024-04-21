
import Foundation

struct MultipartFormBuilder {
    
    static func build(_ request: inout URLRequest, with data: MultipartFormData) {
        request.setValue("multipart/form-data; boundary=\(data.boundary)",
                         forHTTPHeaderField: "Content-Type")
        
        let httpBody = NSMutableData()
        
        data.fields.forEach { field in
            switch field.type {
            case let .data(fileData, fileName, mimeType):
                let data = convertFileData(fieldName: field.name,
                                           fileName: fileName,
                                           mimeType: mimeType?.rawValue,
                                           fileData: fileData,
                                           using: data.boundary)
                httpBody.append(data)
            case .value(let string):
                let value = convertFormField(named: field.name,
                                             value: string,
                                             using: data.boundary)
                httpBody.appendString(value)
            }
        }
        
        request.httpBody = httpBody as Data
    }
}

private extension MultipartFormBuilder {
    static func convertFormField(named name: String, value: String, using boundary: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"
        
        return fieldString
    }
    
    static func convertFileData(fieldName: String,
                                fileName: String,
                                mimeType: String?,
                                fileData: Data,
                                using boundary: String) -> Data
    {
        let data = NSMutableData()
        
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        
        if let mime = mimeType {
            data.appendString("Content-Type: \(mime)\r\n\r\n")
        } else {
            data.appendString("Content-Type: \(fileData.mimeType)\r\n\r\n")
        }
        
        data.append(fileData)
        data.appendString("\r\n")
        
        return data as Data
    }
}
