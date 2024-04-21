import Foundation

/// Тип данных, позволяющий сконфигурировать параметры сервиса обновления данных для авторизации
public final class RefreshOptions {
    /// Свойство, отражающее интервал между рефрешем и повторной попыткой запроса
    ///
    /// Исчесление ведется в наносекундах
    /// Рекомендуемое значение - 1000000000
    let timeoutInterval: RefreshInterval
    
    /// Свойство, отражающее количество возможных повторений рефреша
    /// По-умолчанию равно 1
    var repeatsCount: Int
    
    /// Свойство, отражающее эндпоинт, по которому сервис будет обновлять данные
    let endpoint: RequestEndpoint
    
    /// Свойство, отражающее статус-код, по которому будет осуществляться попытка рефреша.
    /// По-умолчанию равно "401"
    let statusCode: StatusCode
    
    public init(timeoutInterval: RefreshInterval,
                repeatsCount: Int = 1,
                endpoint: RequestEndpoint,
                statusCode: StatusCode = 401)
    {
        self.timeoutInterval = timeoutInterval
        self.repeatsCount = repeatsCount
        self.endpoint = endpoint
        self.statusCode = statusCode
    }
}

extension RefreshOptions {
    /// Стандартные настройки `Refresher`'а
    ///
    /// Данный метод позволяет создать инстанс `RefreshOptions` со стандартными настройками
    public static func `default`(with endpoint: RequestEndpoint) -> RefreshOptions {
        .init(timeoutInterval: 1000000000, repeatsCount: 1, endpoint: endpoint)
    }
}
