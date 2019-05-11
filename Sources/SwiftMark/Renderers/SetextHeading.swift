import Utilities
import Renderer
import Parser
import Lexer

public final class SetextHeading: Syntax {
    public let supportedTokens: [String]

    public init() {
        self.supportedTokens = ["header1", "header2"]
    }

    public func parse(tokens: inout CollectionTracker<[Lexer.Token]>) -> Parser.Token? {
        guard tokens.atStartOfLine() else { return nil }
        var newLines: [Int] = []
        var peekLength = 0

        while let token = tokens.peek(next: peekLength).last, newLines.last != peekLength - 1 {
            if token.name == .newLine { newLines.append(peekLength) }
            peekLength += 1
        }

        guard newLines.count >= 2 && tokens.peek(next: peekLength).last?.name == .newLine else {
            return nil
        }

        let underline = Array(tokens.base[newLines[newLines.count - 2]...newLines[newLines.count - 1]])
        guard let character = underline.first, character.name == (.hyphen || .equal) else {
            return nil
        }
        guard underline == Array(repeating: character, count: underline.count) else {
            return nil
        }

        let contents = tokens.read(next: newLines[newLines.count - 2])
        let depth: Int
        switch character.name {
        case .hyphen: depth = 2
        case .equal: depth = 1
        default: return nil
        }

        tokens.pop(next: underline.count + 1)
        return Parser.Token(name: "header\(depth)", contents: Array(contents))
    }

    public func render(token: Parser.Token) -> Renderer.Result? {
        let number: UInt8
        switch token.name {
        case "header1": number = 1
        case "header2": number = 2
        default: return nil
        }

        switch token.data {
        case let .parserTokens(tokens):
            return .init(start: [60, 104, number, 62], contents: tokens, end: [60, 47, 104, number, 62])
        case let .raw(contents):
            return .init(Array([[60, 104, number, 62], contents, [60, 47, 104, number, 62]].joined()))
        default:
            return nil
        }
    }
}

