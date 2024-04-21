import Foundation


/// Тип события жизненного цикла сервиса AsyncNetworkable
///
/// Данные события может отлавливать любой тип, подписанный на протокол `Eventable` и помещенный в `EventManager`
public enum NetworkEvent {
    /// Событие, отражающее инициализацию сервиса
    case initial(_: ServicIdentifier)
    
    /// Событие, отражающее отправку запроса
    case request(_: EventableRequest)
    
    /// Событие, отражающее получения ответа от сервера
    case response(_: EventableResponse)
    
    /// Событие, отражающее ошибку
    case error(_: NetworkError)
    
    /// Кастомное событие
    /// 
    /// Служит для оповещения пользователя о вторичной информации
    case custom(_: String)
}

extension NetworkEvent {
    public var description: String {
        switch self {
        case .initial(let id):
            "\(id) inited"
        case .request(let r):
            "Request:\n\(r.cURL)"
        case .response(let r):
            "Response:\n\(r.response)"
        case .error(let e):
            "Error:\n\(e.description)"
        case .custom(let s):
            s
        }
    }
}

extension NetworkEvent: Equatable {
    public static func == (lhs: NetworkEvent, rhs: NetworkEvent) -> Bool {
        switch (lhs, rhs) {
        case (let l, let r):
            l.description == r.description
        }
    }
}
