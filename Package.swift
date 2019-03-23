// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "SwiftMark",
    dependencies: [],
    targets: [
        .target(name: "Lexer", dependencies: []),
        .target(name: "SwiftMark", dependencies: ["Lexer"])
    ]
)
