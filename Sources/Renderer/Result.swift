import Parser

extension Renderer {
    public enum Result: ExpressibleByArrayLiteral {
        case parent([UInt8], [Parser.Token], [UInt8])
        case child([UInt8])

        public init(start: [UInt8], contents: [Parser.Token], end: [UInt8]) {
            self = .parent(start, contents, end)
        }

        public init(_ data: [UInt8]) {
            self = .child(data)
        }

        public init(arrayLiteral elements: UInt8...) {
            self = .child(elements)
        }
    }
}
