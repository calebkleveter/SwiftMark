public struct RendererList {
    public let renderers: [TokenRenderer]
    public let `default`: TokenRenderer

    public init(renderers: [TokenRenderer], `default`: TokenRenderer) {
        self.renderers = renderers
        self.default = `default`
    }

    public init(_ `default`: TokenRenderer, _ renderers: TokenRenderer...) {
        self.renderers = renderers
        self.default = `default`
    }
}

extension RendererList: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: TokenRenderer...) {
        guard elements.count > 0, let last = elements.last else {
            preconditionFailure("`GeneratorList` array literal must contain 1 or more elements")
        }

        self = RendererList(renderers: Array(elements[..<elements.index(before: elements.endIndex)]), default: last)
    }
}


