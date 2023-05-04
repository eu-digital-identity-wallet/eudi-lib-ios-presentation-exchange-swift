// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "presentation-exchange-swift",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "presentation-exchange-swift",
            targets: ["presentation-exchange-swift"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "presentation-exchange-swift"),
        .testTarget(
            name: "presentation-exchange-swiftTests",
            dependencies: ["presentation-exchange-swift"]),
    ]
)
