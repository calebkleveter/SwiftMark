import Utilities
import Lexer

public protocol TokenParser {
    func run(on tracker: inout CollectionTracker<[Lexer.Token]>) -> Parser.Result?
}

extension Parser {
    public struct Result {
        public let name: String
        public let value: Value

        public enum Value {
            case metadata(MetadataElement)
            case raw([UInt8])
            case unparsed([Lexer.Token])
            case tokens([Result])
        }

        public init(name: String, contents: [UInt8]) {
            self.name = name
            self.value = .raw(contents)
        }

        public init(name: String, children: [Lexer.Token]) {
            self.name = name
            self.value = .unparsed(children)
        }

        public init(name: String, children: [Result]) {
            self.name = name
            self.value = .tokens(children)
        }

        public init(key: String, value: MetadataElement) {
            self.name = key
            self.value = .metadata(value)
        }

        internal var node: AST.Node? {
            switch self.value {
            case let .raw(data): return AST.Node(name: self.name, data: data)
            case let .tokens(children): return AST.Node(name: self.name, children: children.compactMap { $0.node })
            default: return nil
            }
        }

        public var renderable: Bool {
            switch self.value {
            case .metadata, .raw, .tokens: return true
            case .unparsed: return false
            }
        }
    }
}
