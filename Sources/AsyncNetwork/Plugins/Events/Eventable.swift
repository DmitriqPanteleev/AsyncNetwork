import Foundation

/// Контракт, который должен соблюсти любой тип, обрабатывающий события `NetworkableEvent`, получаемые
/// из сервиса `AsyncNetwork`
public protocol Eventable {
    /// Метод для получения и обработки событий из сервиса `AsyncNetwork`
    func handle(event: NetworkEvent)
}
