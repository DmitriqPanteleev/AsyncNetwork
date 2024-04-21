import Foundation

/// Инстанс, обрабатывающий все события  типа `NetworkableEvent` и направляющий их своим получателям
public final class EventManager {
    
    private var receivers: [any Eventable]
    
    public init(receivers: [any Eventable]) {
        self.receivers = receivers
    }
    
    func notifyAll(with event: NetworkEvent) {
        receivers.forEach { receiver in
            receiver.handle(event: event)
        }
    }
}
