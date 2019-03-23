import Utilities

extension Lexer {
    public struct TokenGenerator {
        public let generator: (inout CollectionTracker<String>) -> Lexer.Token?
        
        public init(generator: @escaping (inout CollectionTracker<String>) -> Lexer.Token?) {
            self.generator = generator
        }
        
        public func run(on tracker: inout CollectionTracker<String>) -> Lexer.Token? {
            return self.generator(&tracker)
        }
    }
    
    public struct Token {
        public let name: String
        public let data: String
        
        public init(name: String, data: String) {
            self.name = name
            self.data = data
        }
    }
}
