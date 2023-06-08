// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUX",
    platforms: [
        // We require Combine so that limits what we support.
        .iOS(.v13),
        .macOS(.v10_15),
        .macCatalyst(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
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
