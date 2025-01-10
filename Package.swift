// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let libraryName = "BlackBox"
let packageName = libraryName
let targetName = libraryName
let testsTargetName = targetName + "Tests"

let exampleModuleName = "ExampleModule"

let package = Package(
    name: packageName,
    platforms: [
        .iOS(.v12),
        .macOS(.v10_14),
        .tvOS(.v12),
        .watchOS(.v5)
    ],
    products: [
        .library(
            name: libraryName,
            targets: [
                targetName
            ]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/dodobrands/DBThreadSafe-ios.git", .upToNextMajor(from: "2.0.0"))
    ],
    targets: [
        .target(
            name: targetName,
            dependencies: [
                .product(name: "DBThreadSafe", package: "DBThreadSafe-ios")
            ]
        ),
        .target(
            name: exampleModuleName,
            dependencies: [
                .init(stringLiteral: targetName)
            ]
        ),
        .testTarget(
            name: testsTargetName,
            dependencies: [
                .init(stringLiteral: targetName),
                .init(stringLiteral: exampleModuleName)
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
