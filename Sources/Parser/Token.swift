import Utilities
import Lexer

public protocol TokenGenerator {
    func run(on tracker: inout CollectionTracker<[Lexer.Token]>) -> Parser.Token?
}

extension Parser {
    public struct Token {
        public let name: String

        public var data: Data {
            didSet {
                switch self.data {
                case .parserTokens, .raw: self.renderable = true
                case .lexerTokens: self.renderable = false
                }
            }
        }

        internal var renderable: Bool

        public init(name: String, contents: [Lexer.Token]) {
            self.name = name
            self.data = .lexerTokens(contents)
            self.renderable = false
        }

        public init(name: String, contents: [UInt8]) {
            self.name = name
            self.data = .raw(contents)
            self.renderable = true
        }

        public init(name: String, data: [Parser.Token]) {
            self.name = name
            self.data = .parserTokens(data)
            self.renderable = true
        }

        public enum Data {
            case lexerTokens([Lexer.Token])
            case parserTokens([Parser.Token])
            case raw([UInt8])
        }
    }
}
