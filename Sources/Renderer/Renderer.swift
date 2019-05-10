import Utilities
import Parser

public final class Renderer {
    public let renderers: HandlerList<TokenRenderer>

    public init(renderers: HandlerList<TokenRenderer>) {
        self.renderers = renderers
    }

    public func render(tokens: [Parser.Token])throws -> [UInt8] {
        var tracker = CollectionTracker(tokens)
        var result: [UInt8] = []

        track: while let token = tracker.peek() {
            defer { tracker.pop() }
            
            if let renderer = self.renderers.handlers.first(where: { $0.renderType == token.name }) {
                if let bytes = renderer.render(token: token) {
                    result.append(contentsOf: bytes)
                    continue track
                }
            }

            guard let bytes = self.renderers.default.render(token: token) else {
                assertionFailure("Renderer.renderers.default _must always_ return bytes")
                throw RendererError.noRendererFound
            }
            result.append(contentsOf: bytes)
        }

        return result
    }
}
