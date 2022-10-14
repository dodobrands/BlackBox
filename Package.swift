// swift-tools-version:5.6
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
    dependencies: [],
    targets: [
        .target(
            name: targetName,
            dependencies: []
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
    swiftLanguageVersions: [.v5]
)
