// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FloadAiAttributionCapacitor",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "FloadAiAttributionCapacitor",
            targets: ["FloadAttributionPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "8.0.0"),
        .package(url: "https://github.com/fload-ai/fload-attribution-ios.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "FloadAttributionPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm"),
                .product(name: "FloadAttribution", package: "fload-attribution-ios")
            ],
            path: "ios/Sources/FloadAttributionPlugin"),
        .testTarget(
            name: "FloadAttributionPluginTests",
            dependencies: ["FloadAttributionPlugin"],
            path: "ios/Tests/FloadAttributionPluginTests")
    ]
)
