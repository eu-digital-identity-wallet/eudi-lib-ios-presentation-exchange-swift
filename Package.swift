// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PresentationExchange",
    platforms: [.iOS(.v14), .macOS(.v12)],
    products: [
        .library(
            name: "PresentationExchange",
            targets: ["PresentationExchange"]),
    ],
    dependencies: [
      .package(
        url: "https://github.com/kylef/JSONSchema.swift",
        from: "0.6.0"
      ),
      .package(
        url: "https://github.com/KittyMac/Sextant.git",
        .upToNextMinor(from: "0.4.0")
      ),
      .package(
        url: "https://github.com/realm/SwiftLint.git",
        .upToNextMinor(from: "0.51.0")
      ),
      .package(
        url: "https://github.com/airsidemobile/JOSESwift.git",
        .upToNextMinor(from: "2.4.0")
      ),
      .package(
        url: "https://github.com/birdrides/mockingbird.git",
        .upToNextMinor(from: "0.20.0")
      )
    ],
    targets: [
        .target(
            name: "PresentationExchange",
            dependencies: [
              .product(
                name: "Sextant",
                package: "Sextant"
              ),
              .product(
                name: "JSONSchema",
                package: "JSONSchema.swift"
              ),
              .product(
                name: "JOSESwift",
                package: "JOSESwift"
              )
            ],
            path: "Sources",
            resources: [
              .process("Resources")
            ],
            plugins: [
              .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
        .testTarget(
            name: "PresentationExchangeTests",
            dependencies: [
              "PresentationExchange",
              .product(
                name: "Mockingbird",
                package: "mockingbird"
              ),
              .product(
                name: "JSONSchema",
                package: "JSONSchema.swift"
              ),
              .product(
                name: "Sextant",
                package: "Sextant"
              ),
              .product(
                name: "JOSESwift",
                package: "JOSESwift"
              )
            ],
            path: "Tests"
        ),
    ]
)
