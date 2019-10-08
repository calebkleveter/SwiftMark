import Utilities
import Renderer
import Parser
import Lexer

public final class Blockquote: Syntax {
    public let supportedTokens: [String]

    public init() {
        self.supportedTokens = ["blockquote"]
    }

    public func parse(tokens: inout CollectionTracker<[Lexer.Token]>) -> Parser.Result? {
        guard tokens.atStartOfLine() else { return nil }

        var lines: [[Lexer.Token]] = []
        while tokens.readable > 0 {
            _ = tokens.read(while: { $0.name == .space }, max: 3)
            if tokens.peek()?.name == .newLine { break }

            if lines.count > 0 && tokens.read()?.name == .greaterThan {
                if tokens.peek()?.name == .space { tokens.pop() }
            }

            let line = tokens.read(while: { $0.name != .newLine })
            tokens.pop()

            lines.append(Array(line))
        }


        return Parser.Result(name: "blockquote", children: Array(lines.joined()))
    }

    public func render(node: AST.Node, metadata: [String: MetadataElement]) -> Renderer.Result? {
        let open: [UInt8] = [60, 98, 108, 111, 99, 107, 113, 117, 111, 116, 101, 62]
        let close: [UInt8] = [60, 47, 98, 108, 111, 99, 107, 113, 117, 111, 116, 101, 62]

        switch node.value {
        case let .children(children): return .init(start: open, contents: children, end: close)
        case let .raw(bytes): return .init(Array([open, bytes, close].joined()))
        }
    }
}

