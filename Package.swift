// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KryptoKit",
    platforms: [
        .iOS(.v13),
        .macOS(.v11),
        .watchOS(.v8),
        .tvOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "KryptoKit",
            targets: ["KryptoKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftverse-dev/StorageKit.git", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "KryptoKit", dependencies: ["StorageKit"]),
        .testTarget(
            name: "KryptoKitTests",
            dependencies: ["KryptoKit"]),
    ]
)
