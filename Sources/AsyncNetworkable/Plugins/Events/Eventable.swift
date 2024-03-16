import Foundation

/// Контракт, который должен соблюсти любой тип, обрабатывающий события `NetworkableEvent`, получаемые
/// из сервиса `AsyncNetworkable`
public protocol Eventable {
    /// Метод для получения и обработки событий из сервиса `AsyncNetworkable`
    func handle(event: NetworkableEvent)
}
