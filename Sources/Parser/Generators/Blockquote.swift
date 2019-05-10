import Utilities
import Lexer

public final class Blockquote: TokenParser {
    public func run(on document: inout CollectionTracker<[Lexer.Token]>) -> Parser.Token? {
        guard document.peek()?.name == .greaterThan else { return nil }

        var contents: [Lexer.Token] = []
        var previousWasNewline = false

        tokens: while let token = document.peek() {
            if previousWasNewline {
                switch token.name {
                case .greaterThan:
                    document.pop()
                    continue tokens
                default: break tokens
                }
            }

            if token.name == .newLine {
                previousWasNewline = true
            } else {
                previousWasNewline = false
                contents.append(token)
            }

            document.pop()
        }

        if contents.count > 0 {
            return Parser.Token(name: "blockquote", contents: contents)
        } else {
            return nil
        }
    }
}
