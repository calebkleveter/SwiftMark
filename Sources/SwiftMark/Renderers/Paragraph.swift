import Utilities
import Renderer
import Parser
import Lexer

public final class Paragraph: Syntax {
    public let supportedTokens: [String]

    public init() {
        self.supportedTokens = ["paragraph"]
    }

    public func parse(tokens: inout CollectionTracker<[Lexer.Token]>) -> Parser.Result? {
        guard tokens.atStartOfLine() else { return nil }
        _ = tokens.read(while: { $0.name == .space }, max: 3)
        guard tokens.peek()?.name != (.space || .newLine) else { return nil }

        var content: [Lexer.Token] = []
        while let token = tokens.read() {
            if token.name == .newLine {
                if content.last?.name == .newLine {
                    break
                } else {
                    _ = tokens.read(while: { $0.name == .space })
                }
            }

            content.append(token)
        }

        return Parser.Result(name: "paragraph", children: content)
    }

    public func render(node: AST.Node, metadata: [String: MetadataElement]) -> Renderer.Result? {
        let start: [UInt8] = [60, 112, 62]
        let end: [UInt8] = [60, 47, 112, 62]

        switch node.value {
        case let .raw(bytes): return .init(start + bytes + end)
        case let .children(nodes): return .init(start: start, contents: nodes, end: end)
        }
    }
}

