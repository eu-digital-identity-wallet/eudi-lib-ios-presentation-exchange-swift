// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PresentationExchange",
    products: [
        .library(
            name: "PresentationExchange",
            targets: ["PresentationExchange"]),
    ],
    targets: [
        .target(
            name: "PresentationExchange"),
        .testTarget(
            name: "PresentationExchangeTests",
            dependencies: ["PresentationExchange"]),
    ]
)
