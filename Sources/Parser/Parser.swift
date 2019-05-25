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
                if let parsed = try self.parse(tokens: tracker, with: generator, to: &result) {
                    tracker.pop(next: parsed)
                } else {
                    continue track
                }
            }

            guard let parsed = try self.parse(tokens: tracker, with: self.generators.default, to: &result) else {
                assertionFailure("Parser.generators.default _must always_ return a token")
                throw ParserError.noGeneratorFound
            }
            tracker.pop(next: parsed)
        }

        return result
    }

    private func parse(
        tokens: CollectionTracker<[Lexer.Token]>,
        with parser: TokenParser,
        to ast: inout AST
    )throws -> Int? {
        var tracker = tokens
        guard let token = parser.run(on: &tracker) else { return nil }

        switch token.value {
        case let .raw(bytes): ast.nodes.append(AST.Node(name: token.name, data: bytes))
        case let .tokens(children): ast.nodes.append(AST.Node(name: token.name, children: children.compactMap { $0.node }))
        case let .metadata(value): ast.metadata[token.name] = value
        case let .unparsed(children):
            let parsed = try self.parse(tokens: children)
            ast.nodes.append(AST.Node(name: token.name, children: parsed.nodes))
        }

        return tracker.readable - tokens.readable
    }
}
