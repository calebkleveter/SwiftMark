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
        var tracker = tokens
        guard tracker.atStartOfLine() else { return nil }
        _ = tracker.read(while: { $0.name == .space }, max: 3)

        guard tracker.read()?.name == .openBracket else { return nil }
        let label = tracker.read(to: Lexer.Token(name: .closeBracket))
        guard label.count > 0 && label.contains(where: { $0.name != .space }) else { return nil }
        tracker.pop()

        guard tracker.read()?.data == .raw([58]) else { return nil }
        var usedLineEnd = false
        _ = tracker.read(while: { token in
            if token.name == .space { return true }
            if token.name == .newLine && !usedLineEnd {
                usedLineEnd = true
                return true
            }

            return false
        })


        let destination: [UInt8]
        if tracker.peek()?.name == .lessThan {
            tracker.pop()
            destination = tracker.read(to: Lexer.Token(name: .greaterThan)).flatMap { $0.bytes }
        } else {
            destination = tracker.read(while: { $0.name != .space || $0.name != .newLine }).flatMap {  $0.bytes }
            guard !destination.has(.control) && !destination.has(.whitespace) else { return nil }
            guard
                Dictionary(grouping: destination, by: { $0 })[40, default: []].count ==
                Dictionary(grouping: destination, by: { $0 })[41, default: []].count
            else {
                return nil
            }
        }

        let title: [UInt8]?
        _ = tracker.read(while: { $0.name == .space })

        if let start = tokens.peek(), start.name != .newLine {
            if start.bytes == [34] {
                title = tracker.read(to: .init(name: .raw, data: [34])).flatMap { $0.bytes }
            } else if start.bytes == [39] {
                title = tracker.read(to: .init(name: .raw, data: [39])).flatMap { $0.bytes }
            } else if start.name == .openParenthese {
                title = tracker.read(to: .init(name: .closeParenthese)).flatMap { $0.bytes }
            } else {
                return nil
            }
        } else {
            title = nil
        }

        let name = String(decoding: label.flatMap { $0.bytes }, as: UTF8.self)
        return Parser.Result(key: "link-\(name)", value: Link(destination: destination, title: title))
    }

    public func render(node: AST.Node, metadata: [String: MetadataElement]) -> Renderer.Result? {
        return nil
    }
}

struct Link: MetadataElement {
    let destination: [UInt8]
    let title: [UInt8]?
}
