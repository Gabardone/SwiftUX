// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUX",
    platforms: [
        // We require Combine so that limits what we support.
        .iOS(.v14),
        .macOS(.v11),
        .macCatalyst(.v14),
        .tvOS(.v14),
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
