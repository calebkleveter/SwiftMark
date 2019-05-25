import Utilities
import Renderer
import Parser
import Lexer

public final class IndentedCodeBlock: Syntax {
    public let supportedTokens: [String]

    public init() {
        self.supportedTokens = ["indentedCode"]
    }

    public func parse(tokens: inout CollectionTracker<[Lexer.Token]>) -> Parser.Result? {
        let previous = tokens.peek(back: 2)
        guard previous == [] || previous.map({ $0.name }) == Array(repeating: .newLine, count: previous.count) else {
            return nil
        }

        var lines: [[UInt8]] = []
        while tokens.readable > 0 {
            if tokens.peek(next: 4).filter({ $0.data == .raw([32]) }).count == 4 {
                tokens.pop(next: 4)
            } else {
                let whitespace = tokens.whiteSpaceLine()
                if whitespace.allWhiteSpace {
                    lines.append(Array(repeating: 32, count: whitespace.length))
                    tokens.pop(next: whitespace.length + 1)
                    continue
                } else {
                    break
                }
            }

            let line = tokens.read(while: { $0.name != .newLine })
            tokens.pop()

            let data = line.flatMap { token -> [UInt8]  in
                switch token.data {
                case .character: return [token.name.value]
                case let .raw(data): return data
                }
            }

            lines.append(data)
        }

        return Parser.Result(name: "indentedCode", contents: Array(lines.joined(separator: [10])))
    }

    public func render(node: AST.Node, metadata: [String: MetadataElement]) -> Renderer.Result? {
        guard node.name == "indentedCode" else { return nil }

        let data: [UInt8]
        switch node.value {
        case let .raw(bytes): data = bytes
        default: return nil
        }

        let result = [
            [60, 112, 114, 101, 62, 60, 99, 111, 100, 101, 62],
            data,
            [10, 60, 47, 99, 111, 100, 101, 62, 60, 47, 112, 114, 101, 62]
        ]

        return .init(Array(result.joined()))
    }
}
