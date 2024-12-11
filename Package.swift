// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppStunSDK",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AppStunSDK",
            targets: ["AppStunSDK"]),
    ],
    dependencies: [
        .package(url: "https://github.com/mobillium/MobilliumBuilders.git", from: "1.6.1"),
        .package(url: "https://github.com/sindresorhus/Defaults.git", from: "8.2.0"),
        .package(name: "Qonversion", url: "https://github.com/qonversion/qonversion-ios-sdk.git", from: "5.6.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AppStunSDK",
            dependencies: [
                "Defaults",
                "MobilliumBuilders",
                "Qonversion"
            ]
        ),
            

    ]
)
