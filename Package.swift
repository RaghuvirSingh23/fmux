// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Fmux",
    platforms: [
        .macOS(.v14),
    ],
    products: [
        .executable(
            name: "Fmux",
            targets: ["Fmux"]
        ),
    ],
    targets: [
        .executableTarget(
            name: "Fmux",
            path: "Sources",
            resources: [
                .copy("Resources/Terminal"),
            ]
        ),
        .testTarget(
            name: "FmuxTests",
            dependencies: ["Fmux"],
            path: "Tests/FmuxTests"
        ),
    ]
)
