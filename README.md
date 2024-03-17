# AsyncNetworkable
[![Language](https://img.shields.io/static/v1.svg?label=language&message=Swift%205&color=FA7343&logo=swift&style=flat-square)](https://swift.org)
[![Platform](https://img.shields.io/static/v1.svg?label=platforms&message=iOS%20&logo=apple&style=flat-square)](https://apple.com)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

## Требования
- iOS 15.0 или выше
- XCode 13.0 или выше

## Примеры использования
### Основной слой
Над данной абстракцией можно написать любой удобный для использования сервис. Прежде всего необходимо описать эндпоинты, которые будет использовать сервис:

```swift
enum AuthEndpoint: RequestEndpoint {
    case signIn
    
    var scheme: RequestScheme {
        .https
    }
    
    var host: String {
        "endpoint.host.com"
    }
    
    var path: String {
        "/api/login"
    }
    
    var method: RequestMethod {
        .post
    }
    
    var body: DynamicDictionary? {
        var params = [String : Any]()
        params["username"] = "username"
        params["password"] = "password"
        return params
    }
}
```

После этого можно приступать к написанию самого сервиса:

```swift
struct AuthService {
    let client: AsyncNetworkable
    
    init(client: AsyncNetworkable) {
        self.client = client
    }
    
    func login() async throws -> Token {
        try await service.sendRequest(with: AuthEndpoint.signIn).decode(to: Token.self)
    }
}
```

### Отправка файлов
Для отправки файла (запрос формата "multipart/form-data") достаточно реализовать для конкретного эндпоинта свойство `fileData` протокола `RequestEndpoint`:
```
    var fileData: MultipartFormData? {
        let field = MultipartFormField(name: name,
                                       data: data,
                                       fileName: fileName,
                                       mimeType: .imagePNG)
        return MultipartFormData(fields: [field])
    }
```

### Рефреш
Для доступности механизма рефреша необходимо и достаточно передать поле `refreshOptions` в инициализатор. Таким образом, гарантируется существование свойства `refreshStream`, к которому можно обращаться и выполнять любую работу при получении новых данных:
```swift
    let refreshTask: Task<Void, Error>
    
    init(client: AsyncNetworkable) {
        self.client = client
        
        self.refreshTask = Task {
            for await refresh in service.refreshStream! {
                let token = try refresh.decode(to: Token.self)
                UserDefaults.standard.setValue(token.token, forKey: "token")
            }
        }
    }
```
Стоит заметить, что при выполнении большого объема работы в данном контексте желательно сделать более значительный `timeoutInterval` в передаваемых `refreshOptions`.

### События и их обработка
Основной сервис в течение своей работы рассылает события типа `NetworkableEvent` всем инстансам, подписанным на протокол `Eventable` и добавленным в `EventManager`. `EventManager` передается в инициализатор основного сервиса.

Одним из таких инстансов является `NetworkableLogger`. Это класс, логирующий весь жизненный цикл запросов. Есть также возможность логировать в журнал событий устройства.
```swift
    let logger = NetworkableLogger(systemLogsEnabled: false)
    let manager = EventManager(receivers: [logger])
    
    let service = AsyncNetworkable(options: .default,
                                   eventManager: manager)
```
В случае, если вас не устраивает стандартная реализация логгера или вам необходим еще один обработчик событий из основного сервиса, то вы можете реализовать свой обработчик, подписав его на протокол `Eventable` и реализовав метод `func handle(event: NetworkableEvent)`:
```swift
final class CustomLogger: Eventable {
    func handle(event: NetworkableEvent) {
        // work with events here
    }
}
```
После реализации необходимо добавить этот инстанс в `EventManager`, передаваемый в основной сервис

## Установка
### Swift Package Manager
[Swift Package Manager](https://swift.org/package-manager/) (SPM) - это инструмент для управления распространением кода Swift, а также зависимостями C-семейства. Начиная с Xcode 11, SPM интегрирован в Xcode.

Данная библиотека поддерживает SPM. Для установки необходимо открыть проект в XCode, нажать `File` -> `Swift Packages` -> `Add Package Dependency` и ввести [URL данной библиотеки](https://github.com/DmitriqPanteleev/AsyncNetworkable.git).

Если вы явялетесь автором библиотеки/фреймворка и используете AsyncNetworkable в качестве зависимости, то вам будет достаточно обновлять свой файл `Package.swift` внутри вашего продукта:
```swift
let package = Package(
    dependencies: [
        .package(url: "https://github.com/DmitriqPanteleev/AsyncNetworkable.git", from: "1.0.0")
    ],
    // ...
)
```

## Лицензия
Данная библиотека лицензирована MIT-лицензией. Для более детальной информации смотреть [лицензию](https://github.com/DmitriqPanteleev/AsyncNetworkable/blob/main/LICENSE)

