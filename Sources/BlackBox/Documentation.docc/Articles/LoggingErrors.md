# Logging Errors
Improved errors logging

### Codes and User Info
`Swift.Error` doesn't provide error code, unless it's inherited from `Int`. But relying on it leads to collisions of error codes once you remove some cases from your custom Error.
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
Each `Swift.Error` is logged with `.error` log level by default.

Implement ``BBLogLevelProvider`` to provide custom log levels for your errors
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
