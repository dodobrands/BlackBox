# Installation
How to add BlackBox to your project

BlackBox Supports:
- iOS 12 and newer;
- macOS 10.14 and newer;
- tvOS 12 and newer;
- watchOS 5 and newer.

SPM:
```swift
dependencies: [
    .package(
        url: "https://github.com/dodopizza/BlackBox.git", 
        .upToNextMajor(from: "1.0.0")
    )
]
```
Carthage:
```ogdl
github "dodopizza/BlackBox"
```

> Note: Do not forget to import to your project
```swift
import BlackBox
```
