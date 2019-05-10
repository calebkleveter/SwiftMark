import Utilities
import Parser
import Lexer

public struct ThematicBreak: Syntax {
    public var renderType: String = "thematicBreak"

    public func parse(tokens: inout CollectionTracker<[Lexer.Token]>) -> Parser.Token? {
        guard tokens.peek(next: -1) == ([.init(name: .newLine)] || []) else { return nil }
        _ = tokens.read(while: { $0.data == .raw([32]) }, max: 3)

        var name: Lexer.Token.Name? = nil
        var count: Int = 0

        while let token = tokens.peek(), token.name != .newLine {
            defer {
                tokens.pop()
                count += 1
            }

            switch token.name {
            case .hyphen, .underscore, .asterisk:
                name? = token.name
                guard token.name == name else { return nil }
            case .raw:
                guard token.data == .raw([32]) else { return nil }
            default: return nil
            }
        }

        return count >= 3 ? Parser.Token(name: self.renderType, contents: [] as [UInt8]) : nil
    }

    public func render(token: Parser.Token) -> [UInt8]? {
        return [60, 104, 114, 47, 62]
    }
}
