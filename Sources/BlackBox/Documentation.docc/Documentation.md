# BlackBox

Library for logs and measurements.

BlackBox provides convenience ways to log and measure what happens in your app: 
- Events;
- Errors;
- How much time it took to execute some code;
- etc.

Moreover, you can redirect the logs wherever you want. Few destinations are supported out of the box, and you can easily add any other destination by yourself.

BlackBox Supports:
- iOS 12 and newer;
- macOS 10.14 and newer;
- tvOS 12 and newer;
- watchOS 5 and newer.

## Installation
### SPM
```swift
dependencies: [
    .package(
        url: "https://github.com/dodopizza/BlackBox.git", 
        .upToNextMajor(from: "1.0.0")
    )
]
```
### Carthage
```ogdl
github "dodopizza/BlackBox"
```

## Usage
```swift
import BlackBox
```

Simple message:
```swift
BlackBox.log("Hello world")
```

Additional info:
```swift
BlackBox.log("Logged in", userInfo: ["userId": someUserId])
```
> Important: Do not include sensitive data in logs

Category:
```swift
BlackBox.log("Logged in", userInfo: ["userId": someUserId], category: "App lifecycle") // keep in mind to not include sensitive info in logs
```

Custom log level:
```swift
BlackBox.log("Tried to open AuthScreen multiple times", level: .warning)
```

Error:
```swift
enum ParsingError: Error {
    case unknownCategoryInDTO(rawValue: Int)
}

BlackBox.log(ParsingError.unknownCategoryInDTO(rawValue: 9))
```

Measurements:
```swift
let log = BlackBox.logStart("Parse menu")
let menuModel = MenuModel(dto: menuDto)
// any other hard work
BlackBox.logEnd(log)
```

> Tip: You can use mix all of the above altogether
```swift
BlackBox.log(
    "Geolocation service started",
    userInfo: ["accuracy": "low"]
    level: .info,
    category: "Location"
)
```


## Loggers

Each logger can filter logs and measurements by levels. You can ask OSLogger to log only `.error` level, but `OSSignpostLogger` to log `.debug` and `.info` levels.
This can be achieved by creating a new instance of logger:
```swift
let logger = OSLogger(levels: [.error]) // or any other desired levels
```

BlackBox automatically enables `OSLogger` and `OSSignpostLogger` with all available log levels.
You can customize this behaviour:
```swift
let loggers = [
    OSLogger(levels: .allCases),
    OSSignpostLogger(levels: [.debug, .info])
    YourCustomLogger()
]
BlackBox.instance = BlackBox(loggers: loggers)
```

## Available loggers
- ``OSLogger`` — logs to macOS Console.app
- ``OSSignpostLogger`` — logs to Time Profiler
- ``FSLogger`` — logs to text file. Doesn't support filesize limits, use at your own risk.


## Custom loggers
1. Create your own logger.
2. Implement ``BBLoggerProtocol``.
3. Add your logger to BlackBox:
```swift
BlackBox.instance = BlackBox(loggers: [YourCustomLogger()])
```

## Errors
### Codes and User Info
Swift.Error doesn't provide error code, unless it's inherited from Int. But relying on inheriting from Int leads to collisions of error codes once you remove some cases from your custom Error.
If you are planning to gather analytics based on your errors you definetely do not want that behaviour.


You can provide custom and fixed error codes and even user info by implementing `CustomNSError` and overriding both `errorCode` and `errorUserInfo` for your Errors.
```swift
extension ParsingError: CustomNSError {
    var errorCode: Int {
        switch self {
        case .unknownCategoryInDTO:
            return 0
        }
    }

    var errorUserInfo: [String : Any] {
        switch self {
        case .unknownCategoryInDTO(let rawValue):
            return ["rawValue": rawValue]
        }
    }
}
```

### Levels
Each Swift.Error is logged with `.error` log level by default.

Implement `BBLogLevelProvider` to provide custom log levels for your errors
```swift
extension ParsingError: BBLogLevelProvider {
    var level: BBLogLevel {
        switch self {
        case .unknownCategoryInDTO(let rawValue):
            if rawValue == 2 { 
                // deprecated category, may be present in orders created before 2019
                return .warning
            } else {
                // unsupported category
                return .error
            }
        }
    }
}
```
