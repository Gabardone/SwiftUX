// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUX",
    platforms: [
        // We require Swift.Logger which limits us to iOS14/macOS11/watchOS7 etc.
        .iOS(.v14),
        .macOS(.v11),
        .macCatalyst(.v14),
        .tvOS(.v14),
        .visionOS(.v1),
        .watchOS(.v7)
    ],
    products: [
        .library(
            name: "SwiftUX",
            targets: ["SwiftUX"]
        )
    ],
    targets: [
        .target(
            name: "SwiftUX",
            dependencies: []
        ),
        .testTarget(
            name: "SwiftUXTests",
            dependencies: ["SwiftUX"]
        )
    ]
)
