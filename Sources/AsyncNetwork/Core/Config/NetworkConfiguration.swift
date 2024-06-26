import Foundation

/// Тип данных, отображающий конфигурацию сервиса `Async Networkable`
///
/// Данный тип необходим для установки следующих свойств:
///  - идентификатор создаваемого сервиса
///  - таймаут  для запросов (по-умолчанию 60.0)
///  - политика кэширования (по-умолчанию зависит от используемого протокола)
///
///  При отсутствии необходимости конфигурировать сервис можно использовать статическое свойство `default`.
public struct NetworkConfiguration {
    /// Идентификатор, который будет присвоен сервису при инициализации
    public let identifier: String
    
    /// Значение таймаута для запросов (по-умолчанию равен 60.0)
    public let timeoutInterval: TimeInterval
    
    /// Политика кэширования для запросов (по-умолчанию зависит от используемого протокола)
    public let cachePolicy: RequestCachePolicy
    
    /// HTTP-хэдеры для всех запросов, отправляемых из сервиса, в который передается конфигурация
    ///
    /// При заполнении данного свойства необходимо помнить, что при наличии заголовка с идентичным ключом
    /// у конкретного экземпляра `RequestEndpoint`,  будет использоваться значение из этого экземпляра,
    /// а не данного свойства
    public var extraHeaders: RequestHeaders
    
    public init(identifier: String,
                timeoutInterval: TimeInterval = 60.0,
                cachePolicy: RequestCachePolicy = .useProtocolCachePolicy,
                extraHeaders: RequestHeaders = [:])
    {
        self.identifier = identifier
        self.timeoutInterval = timeoutInterval
        self.cachePolicy = cachePolicy
        self.extraHeaders = extraHeaders
    }
    
    /// Свойство для создания дефолтной конфигурации
    public static var `default`: Self {
        NetworkConfiguration(identifier: "AsyncNetwork",
                             timeoutInterval: 60.0,
                             cachePolicy: .useProtocolCachePolicy,
                             extraHeaders: [:])
    }
}
