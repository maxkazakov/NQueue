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
        .package(url: "https://github.com/NikSativa/NSpry.git", .upToNextMajor(from: "1.0.1")),
        .package(url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "4.0.0")),
        .package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "9.2.0"))
    ],
    targets: [
        .target(name: "NQueue",
                dependencies: [],
                path: "Source"),
        .target(name: "NQueueTestHelpers",
                dependencies: [
                    "NQueue",
                    "NSpry"
                ],
                path: "TestHelpers"),
        .testTarget(name: "NQueueTests",
                    dependencies: [
                        "NQueue",
                        "NQueueTestHelpers",
                        "NSpry",
                        "Nimble",
                        "Quick",
                    ],
                    path: "Tests"
        )
    ],
    swiftLanguageVersions: [.v5]
)
