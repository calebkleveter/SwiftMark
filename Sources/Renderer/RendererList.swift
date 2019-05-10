public struct RendererList {
    public let generators: [TokenRenderer]
    public let `default`: TokenRenderer

    public init(generators: [TokenRenderer], `default`: TokenRenderer) {
        self.generators = generators
        self.default = `default`
    }

    public init(_ `default`: TokenRenderer, _ generators: TokenRenderer...) {
        self.generators = generators
        self.default = `default`
    }
}

extension GeneratorList: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: TokenRenderer...) {
        guard elements.count > 0, let last = elements.last else {
            preconditionFailure("`GeneratorList` array literal must contain 1 or more elements")
        }

        self = GeneratorList(generators: Array(elements[..<elements.index(before: elements.endIndex)]), default: last)
    }
}


