import Utilities

public final class Lexer {
    public let generators: [TokenGenerator]
    public let defaultGenerator: TokenGenerator
    
    public init(generators: [TokenGenerator], defaultGenerator: TokenGenerator) {
        self.generators = generators
        self.defaultGenerator = defaultGenerator
    }
    
    public func lex(string: String)throws -> [Token] {
        var tracker = CollectionTracker(string)
        var result: [Token] = []
        
        track: while tracker.readable > 0 {
            for generator in self.generators {
                if let token = generator.run(on: &tracker) {
                    result.append(token)
                    continue track
                }
            }
            guard let token = self.defaultGenerator.run(on: &tracker) else {
                assertionFailure("Lexer.defaultGenerator _must always_ return a token")
                throw LexerError.noGeneratorFound
            }
            result.append(token)
        }
        
        return result
    }
}
