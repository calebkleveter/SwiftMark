import Foundation
import Utilities

public final class Lexer {
    public let generators: HandlerList<TokenGenerator>

    public init(generators: HandlerList<TokenGenerator>) {
        self.generators = generators
    }
    
    public func clean(data: [UInt8]) -> [UInt8] {
        return data.flatMap { $0 == 0 ? [239, 191, 189] : [$0] }
    }
    
    public func lex(string: [UInt8])throws -> [Token] {
        var tracker = CollectionTracker(string)
        var result: [Token] = []
        
        track: while tracker.readable > 0 {
            for generator in self.generators.handlers {
                if let tokens = generator.run(on: &tracker), tokens.count > 0 {
                    result.append(contentsOf: tokens)
                    continue track
                }
            }
            guard let tokens = self.generators.default.run(on: &tracker), tokens.count > 0 else {
                assertionFailure("Lexer.defaultGenerator _must always_ return a token")
                throw LexerError.noGeneratorFound
            }
            result.append(contentsOf: tokens)
        }

        return result
    }
}
