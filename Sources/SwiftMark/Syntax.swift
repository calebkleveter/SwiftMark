import Lexer
import Parser
import Renderer
import Utilities

public protocol Syntax: TokenParser, TokenRenderer {
    func parse(tokens: inout CollectionTracker<[Lexer.Token]>) -> Parser.Token?
}

extension Syntax {
    func run(on tracker: inout CollectionTracker<[Lexer.Token]>) -> Parser.Token? {
        return self.parse(tokens: &tracker)
    }
}
