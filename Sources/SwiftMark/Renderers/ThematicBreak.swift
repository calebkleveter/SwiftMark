import Utilities
import Parser
import Lexer

public struct ThematicBreak: Syntax {
    public let renderType: String

    public init() {
        self.renderType = "thematicBreak"
    }

    public func parse(tokens: inout CollectionTracker<[Lexer.Token]>) -> Parser.Token? {
        guard tokens.atStartOfLine() else { return nil }
        _ = tokens.read(while: { $0.data == .raw([32]) }, max: 3)

        var name: Lexer.Token.Name? = nil
        var count: Int = 0
        peek: while let token = tokens.peek() {
            defer { tokens.pop() }

            switch token.name {
            case .hyphen, .underscore, .asterisk:
                if name == nil { name = token.name }
                guard token.name == name else { return nil }
                count += 1
            case .raw:
                guard token.data == .raw([32]) else { return nil }
            case .newLine: break peek
            default: return nil
            }
        }

        return count >= 3 ? Parser.Token(name: self.renderType, contents: [] as [UInt8]) : nil
    }

    public func render(token: Parser.Token) -> [UInt8]? {
        return [60, 104, 114, 47, 62]
    }
}
