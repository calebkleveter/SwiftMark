extension Lexer {
    public struct TokenGenerator {
        public let generator: (String) -> Lexer.Token
        
        public init(generator: @escaping (String) -> Lexer.Token) {
            self.generator = generator
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
