import Utilities
import Lexer

public final class Parser {
    public let generators: HandlerList<TokenParser>

    public init(generators: HandlerList<TokenParser>) {
        self.generators = generators
    }

    public func parse(tokens: [Lexer.Token])throws -> AST {
        var tracker = CollectionTracker(tokens)
        var result = AST()

        track: while tracker.readable > 0 {
            for generator in self.generators.handlers {
                if let token = generator.run(on: &tracker) {
                    if token.renderable {
                        result.append(token)
                    } else {
                        guard case let .unparsed(contents) = token.value else {
                            assertionFailure("This case can technically never be reached. Please file a bug.")
                            throw ParserError.noParsableTokens
                        }

                        let children = try self.parse(tokens: contents)
                        result.append(AST.Node(name: token.name, children: children.nodes))
                    }

                    continue track
                }
            }

            guard let token = self.generators.default.run(on: &tracker) else {
                assertionFailure("Parser.generators.default _must always_ return a token")
                throw ParserError.noGeneratorFound
            }
            
            if !token.renderable {
                guard case let .unparsed(contents) = token.value else {
                    assertionFailure("This case can technically never be reached. Please file a bug.")
                    throw ParserError.noParsableTokens
                }

                let children = try self.parse(tokens: contents)
                result.append(AST.Node(name: token.name, children: children.nodes))
            } else {
                result.append(token)
            }
        }

        return result
    }
}
