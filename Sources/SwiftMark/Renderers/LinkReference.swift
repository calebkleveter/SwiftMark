import Utilities
import Renderer
import Parser
import Lexer

public final class LinkReference: Syntax {
    public var supportedTokens: [String]

    public init() {
        self.supportedTokens = []
    }

    public func parse(tokens: inout CollectionTracker<[Lexer.Token]>) -> Parser.Result? {
        guard tokens.atStartOfLine() else { return nil }
        _ = tokens.read(while: { $0.name == .space }, max: 3)

        guard tokens.read()?.name == .openBracket else { return nil }
        let label = tokens.read(to: Lexer.Token(name: .closeBracket))
        guard label.count > 0 && label.contains(where: { $0.name != .space }) else { return nil }
        tokens.pop()

        guard tokens.read()?.data == .raw([58]) else { return nil }
        var usedLineEnd = false
        _ = tokens.read(while: { token in
            if token.name == .space { return true }
            if token.name == .newLine && !usedLineEnd {
                usedLineEnd = true
                return true
            }

            return false
        })


        let destination: [UInt8]
        if tokens.peek()?.name == .lessThan {
            tokens.pop()
            destination = tokens.read(to: Lexer.Token(name: .greaterThan)).flatMap { $0.bytes }
            tokens.pop()
        } else {
            destination = tokens.read(while: { $0.name != .space || $0.name != .newLine }).flatMap {  $0.bytes }
            guard !destination.has(.control) && !destination.has(.whitespace) else { return nil }
            guard
                Dictionary(grouping: destination, by: { $0 })[40, default: []].count ==
                Dictionary(grouping: destination, by: { $0 })[41, default: []].count
            else {
                return nil
            }
        }

        let title: [UInt8]?
        _ = tokens.read(while: { $0.name == .space })

        if let start = tokens.read(), start.name != .newLine {
            let token: Lexer.Token
            if start.bytes == [34] {
                token = .init(name: .raw, data: [34])
            } else if start.bytes == [39] {
                token = .init(name: .raw, data: [39])
            } else if start.name == .openParenthese {
                token = .init(name: .closeParenthese)
            } else {
                return nil
            }

            title = tokens.read(to: token).flatMap { $0.bytes }
            tokens.pop()
        } else {
            title = nil
        }

        let name = String(decoding: label.flatMap { $0.bytes }, as: UTF8.self)
        return Parser.Result(key: "link-\(name)", value: Link(title: title, destination: destination))
    }

    public func render(node: AST.Node, metadata: [String: MetadataElement]) -> Renderer.Result? {
        return nil
    }
}

public struct Link: MetadataElement {
    public let destination: [UInt8]
    public let title: [UInt8]?

    public init(title: [UInt8]?, destination: [UInt8]) {
        self.destination = destination
        self.title = title
    }
}
