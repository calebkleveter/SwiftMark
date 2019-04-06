// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "SwiftMark",
    dependencies: [],
    targets: [
        .target(name: "Utilities", dependencies: []),
        .target(name: "Lexer", dependencies: ["Utilities"]),
        .target(name: "Parser", dependencies: ["Lexer", "Utilities"]),
        .target(name: "SwiftMark", dependencies: ["Lexer"]),
        
        .testTarget(name: "LexerTests", dependencies: ["Utilities", "Lexer"])
    ]
)
