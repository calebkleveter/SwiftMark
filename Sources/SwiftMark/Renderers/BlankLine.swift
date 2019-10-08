import Utilities
import Renderer
import Parser
import Lexer

public final class BlankLine: Syntax {
    public let supportedTokens: [String]

    public init() {
        self.supportedTokens = ["blankLine"]
    }

    public func parse(tokens: inout CollectionTracker<[Lexer.Token]>) -> Parser.Result? {
        while tokens.readable > 0 {
            let line = tokens.whiteSpaceLine()

            guard line.allWhiteSpace else {
                return nil
            }

            tokens.pop(next: line.length)
            tokens.pop()
        }

        return Parser.Result(name: "blankLine", contents: [])
    }

    public func render(node: AST.Node, metadata: [String: MetadataElement]) -> Renderer.Result? {
        return []
    }
}
