// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DeepSeek-iOS",
    platforms: [
        .iOS(.v16)
    ],
    targets: [
        .target(
            name: "DeepSeek",
            path: ".",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
