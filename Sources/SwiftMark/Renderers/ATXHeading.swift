import Utilities
import Renderer
import Parser
import Lexer

public final class ATXHeading: Syntax {
    public var supportedTokens: [String]

    public init() {
        self.supportedTokens = (1...6).map { "header\($0)" }
    }

    public func parse(tokens: inout CollectionTracker<[Lexer.Token]>) -> Parser.Token? {
        guard tokens.atStartOfLine() else { return nil }
        _  = tokens.read(while: { $0.data == .raw([32])}, max: 3)

        var depth = 0
        while tokens.peek()?.name == .hash, depth <= 6 { depth += 1 }

        if tokens.peek()?.name == .newLine {
            tokens.pop(next: depth + 1)
            return Parser.Token(name: "header\(depth)", contents: [] as [UInt8])
        } else if tokens.peek()?.data == .raw([32]) {
            tokens.pop(next: depth + 1)
        } else {
            return nil
        }
        _ = tokens.read(while: { $0.data == .raw([32])})

        var contents: [Lexer.Token] = []
        var escaped: Bool = false

        var cache: [Lexer.Token] = []
        while let token = tokens.peek() {
            defer { tokens.pop() }

            if escaped {
                contents.append(token)
                escaped.toggle()
                continue
            }

            if token.name == .backSlash {
                escaped = true
            } else if token.name == .newLine {
                break
            } else if token.name == .hash {
                if cache.last?.data == .raw([32]) || cache.last?.name == .hash {
                    cache.append(token)
                } else {
                    contents.append(token)
                }
            } else if token.data == .raw([32]) {
                cache.append(token)
            } else {
                contents.append(contentsOf: cache)
                contents.append(token)
                cache = []
            }

        }

        return Parser.Token(name: "header\(depth)", contents: contents)
    }

    public func render(token: Parser.Token) -> Renderer.Result? {
        let number: UInt8
        switch token.name {
        case "header1": number = 49
        case "header2": number = 50
        case "header3": number = 51
        case "header4": number = 52
        case "header5": number = 53
        case "header6": number = 54
        default: return nil
        }

        switch token.data {
        case let .parserTokens(tokens): return .init(start: [60, 104, number, 62], contents: tokens, end: [60, 104, number, 62])
        case let .raw(contents): return .init(Array([[60, 104, number, 62], contents, [60, 104, number, 62]].joined()))
        default: return nil
        }
    }
}
