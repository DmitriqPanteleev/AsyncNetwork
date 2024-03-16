
import Foundation

/// Тип данных, отображающий ответ на HTTP-запрос
public struct EventableResponse {
    /// HTTP-запрос и описанный к нему `RequestEndpoint`, по которым пришел ответ
    public let request: EventableRequest
    
    /// Ответ, полученный в результате запроса
    public let response: Response
    
    /// Данные, полученные в результате запроса
    public let data: Data
    
    /// Статус-код, полученный в результате запроса
    public let statusCode: StatusCode
}
