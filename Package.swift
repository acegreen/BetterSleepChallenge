// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BetterSleepChallenge",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "BetterSleepChallenge",
            targets: ["BetterSleepChallenge"]),
    ],
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint", from: "0.52.4")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "BetterSleepChallenge",
            dependencies: [],
            plugins: [
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
            ]),
        .testTarget(
            name: "BetterSleepChallengeTests",
            dependencies: ["BetterSleepChallenge"]),
    ]
)
