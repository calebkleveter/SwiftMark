import Utilities
import Renderer
import Parser
import Lexer

public final class SetextHeading: Syntax {
    public let supportedTokens: [String]

    public init() {
        self.supportedTokens = ["header1", "header2"]
    }

    public func parse(tokens: inout CollectionTracker<[Lexer.Token]>) -> Parser.Result? {
        guard tokens.atStartOfLine() else { return nil }

        var contents: [Lexer.Token] = []
        var depth = 0

        reader: while tokens.readable > 0 {
            _ = tokens.read(while: { $0.name == .space }, max: 3)
            let line = tokens.read(while: { $0.name != .newLine })
            guard let newLine = tokens.read() else { return nil }

            guard let prefix = line.first, prefix.name != .space else { return nil }

            switch prefix.name {
            case .hyphen, .equal:
                if Array(line) == Array(repeating: prefix, count: line.count) {
                    depth = prefix.name == .equal ? 1 : 2
                    break reader
                }
                fallthrough
            default:
                contents.append(contentsOf: line)
                contents.append(newLine)
            }
        }

        return Parser.Result(name: "header\(depth)", children: contents.dropLast())
    }

    public func render(node: AST.Node, metadata: [String: MetadataElement]) -> Renderer.Result? {
        let number: UInt8
        switch node.name {
        case "header1": number = 1
        case "header2": number = 2
        default: return nil
        }

        switch node.value {
        case let .children(tokens):
            return .init(start: [60, 104, number, 62], contents: tokens, end: [60, 47, 104, number, 62])
        case let .raw(contents):
            return .init(Array([[60, 104, number, 62], contents, [60, 47, 104, number, 62]].joined()))
        }
    }
}

