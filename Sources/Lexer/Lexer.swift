import Foundation
import Utilities

public final class Lexer {
    public let generators: GeneratorList

    public init(generators: GeneratorList) {
        self.generators = generators
    }
    
    public func clean(data: [UInt8]) -> [UInt8] {
        return data.flatMap { $0 == 0 ? [239, 191, 189] : [0] }
    }
    
    public func lex(string: [UInt8])throws -> Document<[Token]> {
        var tracker = CollectionTracker(string)
        var result = Document<[Token]>()
        var line: [Token] = []
        
        track: while tracker.readable > 0 {
            for generator in self.generators.generators {
                if let tokens = generator.run(on: &tracker), tokens.count > 0 {
                    if let gen = generator as? NewLineGeneratorProtocol {
                        let ending = gen.ending(for: tokens)
                        result.lines.append(.line(.init(line), ending))
                        line = []
                    } else {
                        line.append(contentsOf: tokens)
                    }
                    continue track
                }
            }
            guard let tokens = self.generators.default.run(on: &tracker), tokens.count > 0 else {
                assertionFailure("Lexer.defaultGenerator _must always_ return a token")
                throw LexerError.noGeneratorFound
            }
            line.append(contentsOf: tokens)
        }

        result.lines.append(.line(.init(line), .eof))
        return result
    }
}
