import Utilities
import Lexer

public protocol TokenGenerator {
    func run(on tracker: Document<[Lexer.Token]>) -> Parser.Token?
}

extension Parser {
    public struct Token {
        public let name: String
        public let data: String
        public let position: TokenPosition
        
        public init(name: String, data: String, position: TokenPosition) {
            self.name = name
            self.data = data
            self.position = position
        }
    }
    
    public enum TokenPosition {
        case open
        case close
    }
}
