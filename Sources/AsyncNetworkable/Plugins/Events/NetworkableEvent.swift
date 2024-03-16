import Foundation


/// Тип события жизненного цикла сервиса AsyncNetworkable
///
/// Данные события может отлавливать любой тип, подписанный на протокол `Eventable` и помещенный в `EventManager`
public enum NetworkableEvent {
    /// Событие, отражающее инициализацию сервиса
    case initial(_: ServicIdentifier)
    
    /// Событие, отражающее отправку запроса
    case request(_: EventableRequest)
    
    /// Событие, отражающее получения ответа от сервера
    case response(_: EventableResponse)
    
    /// Событие, отражающее ошибку
    case error(_: NetworkableError)
    
    /// Кастомное событие
    /// 
    /// Служит для оповещения пользователя о вторичной информации
    case custom(_: String)
}
