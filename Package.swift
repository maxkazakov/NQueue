// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "NQueue",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(name: "NQueue", targets: ["NQueue"]),
        .library(name: "NQueueTestHelpers", targets: ["NQueueTestHelpers"])
    ],
    dependencies: [
        .package(url: "https://github.com/NikSativa/Spry.git", .upToNextMajor(from: "3.4.3")),
        .package(url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "3.1.2")),
        .package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "9.0.0"))
    ],
    targets: [
        .target(name: "NQueue",
                dependencies: [],
                path: "Source"),
        .target(name: "NQueueTestHelpers",
                dependencies: [
                    "NQueue",
                    "Nimble",
                    "Spry"
                ],
                path: "TestHelpers"),
        .testTarget(name: "NQueueTests",
                    dependencies: [
                        "NQueue",
                        "NQueueTestHelpers",
                        "Spry",
                        "Nimble",
                        "Quick",
                        .product(name: "Spry_Nimble", package: "Spry")
                    ],
                    path: "Tests/Specs"
        )
    ],
    swiftLanguageVersions: [.v5]
)
