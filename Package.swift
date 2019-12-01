// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "MarkdownKit",
    products: [
        .library(name: "MarkdownKit", targets: ["MarkdownKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-cmark", .branch("master")),
    ],
    targets: [
        .target(name: "MarkdownKit", dependencies: ["cmark"]),
        .testTarget(name: "MarkdownKitTests", dependencies: ["MarkdownKit"]),
    ]
)
