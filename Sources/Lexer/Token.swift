import Utilities

public protocol TokenGenerator {
    func run(on tracker: inout CollectionTracker<String>) -> Lexer.Token?
}

extension Lexer {    
    public struct Token {
        public let name: String
        public let data: String
        
        public init(name: String, data: String) {
            self.name = name
            self.data = data
        }
    }
}
