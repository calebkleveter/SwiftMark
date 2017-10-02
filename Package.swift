import PackageDescription

let package = Package(
    name: "SwiftMark",
    targets: [
        Target(name: "Version2"),
        Target(name: "Lexer"),
        Target(name: "Parser", dependencies: ["Lexer"]),
        Target(name: "Renderer", dependencies: ["Parser"]),
        Target(name: "SwiftMark", dependencies: ["Lexer", "Parser", "Renderer"])
    ]
)
