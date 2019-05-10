import Utilities
import Lexer

public final class Parser {
    public let generators: HandlerList<TokenParser>

    public init(generators: HandlerList<TokenParser>) {
        self.generators = generators
    }

    public func parse(tokens: [Lexer.Token])throws -> [Parser.Token] {
        var tracker = CollectionTracker(tokens)
        var result: [Parser.Token] = []

        track: while tracker.readable > 0 {
            for generator in self.generators.handlers {
                if var token = generator.run(on: &tracker) {
                    if token.renderable {
                        result.append(token)
                    } else {
                        guard case let .lexerTokens(contents) = token.data else {
                            assertionFailure("This case can technically never be reached. Please file a bug.")
                            throw ParserError.noParsableTokens
                        }

                        let data = try self.parse(tokens: contents)
                        token.data = .parserTokens(data)
                        result.append(token)
                    }

                    continue track
                }
            }

            guard let token = self.generators.default.run(on: &tracker) else {
                assertionFailure("Parser.generators.default _must always_ return a token")
                throw ParserError.noGeneratorFound
            }

            result.append(token)
        }

        return result
    }
}
