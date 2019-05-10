public struct HandlerList<Handler> {
    public let handlers: [Handler]
    public let `default`: Handler

    public init(handlers: [Handler], `default`: Handler) {
        self.handlers = handlers
        self.default = `default`
    }

    public init(_ `default`: Handler, _ handlers: Handler...) {
        self.handlers = handlers
        self.default = `default`
    }
}

extension HandlerList: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Handler...) {
        guard elements.count > 0, let last = elements.last else {
            preconditionFailure("`GeneratorList` array literal must contain 1 or more elements")
        }

        self = HandlerList(handlers: Array(elements[..<elements.index(before: elements.endIndex)]), default: last)
    }
}

