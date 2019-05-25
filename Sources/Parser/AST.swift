import Utilities
import Lexer

public protocol MetadataElement { }

public struct AST {
    public internal(set) var metadata: [String: MetadataElement]
    public internal(set) var nodes: [Node]

    public init(nodes: [Node] = [], metadata: [String: MetadataElement] = [:]) {
        self.nodes = nodes
        self.metadata = metadata
    }

    public mutating func append(_ token: Parser.Result) {
        switch token.value {
        case let .metadata(value): self.metadata[token.name] = value
        case .raw, .tokens: if let node = token.node { self.nodes.append(node) }
        case .unparsed: return
        }
    }

    public mutating func append(_ node: Node) {
        self.nodes.append(node)
    }

    public struct Node {
        public let name: String
        public let value: Value

        public init(name: String, data: [UInt8]) {
            self.name = name
            self.value = .raw(data)
        }

        public init(name: String, children: [Node]) {
            self.name = name
            self.value = .children(children)
        }

        public enum Value {
            case raw([UInt8])
            case children([Node])
        }
    }
}
