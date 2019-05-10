public struct GeneratorList {
    public let generators: [TokenGenerator]
    public let `default`: TokenGenerator

    public init(generators: [TokenGenerator], `default`: TokenGenerator) {
        self.generators = generators
        self.default = `default`
    }

    public init(_ `default`: TokenGenerator, _ generators: TokenGenerator...) {
        self.generators = generators
        self.default = `default`
    }
}

extension GeneratorList: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: TokenGenerator...) {
        guard elements.count > 0, let last = elements.last else {
            preconditionFailure("`GeneratorList` array literal must contain 1 or more elements")
        }

        self = GeneratorList(generators: Array(elements[..<elements.index(before: elements.endIndex)]), default: last)
    }
}

