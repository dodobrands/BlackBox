# BlackBox
iOS wrapper library for Unified Logging, and more.

## Installation

```
1. Add BlackBox as a dependency
```
pod 'BlackBox', :source => 'git@github.com:dodopizza/dodo_pods.git'
```
2. Import to your project
```
import BlackBox
```
3. Configure instance with desired loggers
```
BlackBox.instance = BlackBox(loggers: [BlackBox.OSLogger()])
```

## Available loggers
1. `OSLogger` — logs to macOS Console.app
2. `FSLogger` — logs to file. Slow, use at your own risk.
3. `OSSignpostLogger` — logs to Time Profiler

## Usage
1. Simple message
```
BlackBox.log("Hello world")
```
2. Message with additional info
```
BlackBox.log("Logged in", userInfo: ["userId": someUserId]) // keep in mind to not include sensitive info in logs
```
3. Message with custom log level
```
BlackBox.log("Tried to open AuthScreen multiple times", logLevel: .warning)
```
4. Error
```
enum ParsingError: Error {
    case unknownCategoryInDTO(rawValue: Int)
}

BlackBox.log(ParsingError.unknownCategoryInDTO(rawValue: 9))
```
5. Time Profiler, `OSSignpostLogger` is required
```
BlackBox.log("Will parse menu", eventType: .begin)
let menuModel = MenuModel(dto: menuDto)
BlackBox.log("Did parse menu", eventType: .end)
```
6. Time Profiler with concurrent async operations
```
let eventId = UInt64.random // basically any uniqie UInt64 is required

BlackBox.log("Will load data for network request", eventType: .begin, eventId: eventId)
request.get() { response in
    BlackBox.log("Did load data for request", eventType: .end, eventId: eventId)
}
```

## Adding custom loggers
Create your own logger and implement `BBLoggerProtocol`

### Example
```
extension BlackBox {
    class CrashlyticsLogger: BBLoggerProtocol {
        func log(_ error: Error,
                 file: StaticString,
                 function: StaticString,
                 line: UInt) {
            Crashlytics.crashlytics().record(error: error)
        }

        func log(_ message: String,
                 userInfo: CustomDebugStringConvertible?,
                 logLevel: BBLogLevel,
                 eventType: BBEventType?,
                 eventId: UInt64?,
                 file: StaticString,
                 function: StaticString,
                 line: UInt) {
            return
        }
    }
}
```
And dont forget to add your custom logger to BlackBox
```
BlackBox.instance = BlackBox(loggers: [BlackBox.OSLogger(), BlackBox.CrashlyticsLogger()])
```

For better Crashlytics support implement `CustomNSError` and override both `errorCode` and `errorUserInfo` 
```
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
