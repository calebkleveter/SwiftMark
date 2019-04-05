import Utilities

public protocol TokenGenerator {
    func run(on tracker: inout CollectionTracker<[Lexer.Line]>) -> Lexer.Token?
}

extension Lexer {    
    public struct Token: Equatable {
        public enum Storage: Equatable {
            case raw(String)
            case character
        }
        
        public let name: String
        public let data: Storage
        
        public init(name: String, data: String) {
            self.name = name
            self.data = .raw(data)
        }
        
        public init(name: String) {
            self.name = name
            self.data = .character
        }
    }
}
