import Utilities
import Renderer
import Parser
import Lexer

public final class ATXHeading: Syntax {
    public var supportedTokens: [String]

    public init() {
        self.supportedTokens = (1...6).map { "header\($0)" }
    }

    public func parse(tokens: inout CollectionTracker<[Lexer.Token]>) -> Parser.Result? {
        guard tokens.atStartOfLine() else { return nil }
        _  = tokens.read(while: { $0.name == .space}, max: 3)

        let depth = tokens.read(while: { $0.name == .hash }).count
        guard depth <= 6 else { return nil }

        guard let next = tokens.read(), next.name != .newLine else {
            return Parser.Result(name: "header\(depth)", contents: [])
        }
        guard next.name == .space else {
            return nil
        }
        _ = tokens.read(while: { $0.name == .space })

        var contents: [Lexer.Token] = []
        var cache: [Lexer.Token] = []

        reader: while let token = tokens.read() {
            switch token.name {
            case .newLine: break reader
            case .hash:
                if cache.count == 0 || cache.last?.name == (.space || .hash) {
                    cache.append(token)
                } else {
                    contents.append(token)
                }
            case .space: cache.append(token)
            default:
                contents.append(contentsOf: cache)
                contents.append(token)
                cache = []
            }
        }

        return Parser.Result(name: "header\(depth)", children: contents)
    }

    public func render(node: AST.Node, metadata: [String: MetadataElement]) -> Renderer.Result? {
        let number: UInt8
        switch node.name {
        case "header1": number = 49
        case "header2": number = 50
        case "header3": number = 51
        case "header4": number = 52
        case "header5": number = 53
        case "header6": number = 54
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
