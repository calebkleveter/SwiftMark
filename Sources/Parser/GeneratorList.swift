public struct GeneratorList {
    public let generators: [TokenParser]
    public let `default`: TokenParser

    public init(generators: [TokenParser], `default`: TokenParser) {
        self.generators = generators
        self.default = `default`
    }

    public init(_ `default`: TokenParser, _ generators: TokenParser...) {
        self.generators = generators
        self.default = `default`
    }
}

extension GeneratorList: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: TokenParser...) {
        guard elements.count > 0, let last = elements.last else {
            preconditionFailure("`GeneratorList` array literal must contain 1 or more elements")
        }

        self = GeneratorList(generators: Array(elements[..<elements.index(before: elements.endIndex)]), default: last)
    }
}

