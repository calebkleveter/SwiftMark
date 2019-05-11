import Utilities
import Parser

public final class Renderer {
    public let rendererMap: [String: TokenRenderer]
    public let defaultRenderer: TokenRenderer

    public init(renderers: HandlerList<TokenRenderer>) {
        self.rendererMap = renderers.handlers.reduce(into: [:]) { map, renderer in
            renderer.supportedTokens.forEach { key in
                map[key] = renderer
            }
        }
        self.defaultRenderer = renderers.default
    }

    public func render(tokens: [Parser.Token])throws -> [UInt8] {
        var tracker = CollectionTracker(tokens)
        var result: [UInt8] = []

        track: while let token = tracker.peek() {
            defer { tracker.pop() }
            
            if let renderer = self.rendererMap[token.name] {
                if let rendered = renderer.render(token: token) {
                    switch rendered {
                    case let .parent(start, contents, end):
                        result.append(contentsOf: start)
                        try result.append(contentsOf: self.render(tokens: contents))
                        result.append(contentsOf: end)
                    case let .child(data): result.append(contentsOf: data)
                    }

                    continue track
                }
            }

            guard let rendered = self.defaultRenderer.render(token: token) else {
                assertionFailure("Renderer.renderers.default _must always_ return bytes")
                throw RendererError.noRendererFound
            }
            switch rendered {
            case let .parent(start, contents, end):
                result.append(contentsOf: start)
                try result.append(contentsOf: self.render(tokens: contents))
                result.append(contentsOf: end)
            case let .child(data): result.append(contentsOf: data)
            }
        }

        return result
    }
}
