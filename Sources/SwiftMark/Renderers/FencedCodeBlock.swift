import Utilities
import Renderer
import Parser
import Lexer

public final class FencedCodeBlock: Syntax {
    public let supportedTokens: [String]
    public let languagePrefix: [UInt8]

    public init(languagePrefix: String = "language-") {
        self.supportedTokens = ["fencedCode"]
        self.languagePrefix = Array(languagePrefix.utf8)
    }

    public func parse(tokens: inout CollectionTracker<[Lexer.Token]>) -> Parser.Result? {
        guard tokens.atStartOfLine() else { return nil }

        var indentation = 0
        while tokens.peek(next: indentation + 1).last?.name == .space { indentation += 1 }
        guard indentation <= 3 else { return nil }
        tokens.pop(next: indentation)

        guard let character = tokens.peek(), character.name == (.backtick || .tilde) else { return nil }
        let fence = tokens.read(while: { $0.name == character.name })
        let infoString = tokens.read(while: { $0.name != .newLine })

        tokens.pop()

        var lines: [[UInt8]] = []
        while tokens.readable > 0 {
            var indented = 0
            let line = tokens.read(while: { $0.name != .newLine }).drop(while: { token in
                defer { indented += 1 }
                return token.name == .space && indented < indentation
            })
            tokens.pop()

            if line == fence { break }
            let data = line.flatMap { token -> [UInt8]  in
                switch token.data {
                case .character: return [token.name.value]
                case let .raw(data): return data
                }
            }

            lines.append(data)
        }

        if let token = infoString.first, case let .raw(language) = token.data {
            return Parser.Result(name: "fencedCode", children: [
                Parser.Result(name: "language", contents: language),
                Parser.Result(name: "contents", contents: Array(lines.joined(separator: [10])))
            ])
        } else {
            return Parser.Result(name: "fencedCode", contents: Array(lines.joined(separator: [10])))
        }
    }

    public func render(node: AST.Node, metadata: [String: MetadataElement]) -> Renderer.Result? {
        guard node.name == "fencedCode" else { return nil }

        let language: [UInt8]?
        let contents: [UInt8]

        switch node.value {
        case let .raw(data):
            language = nil
            contents = data
        case let .children(tokens):
            guard tokens.count == 2 else { return nil }
            guard case let .raw(lang) = tokens[0].value else { return nil }
            guard case let .raw(data) = tokens[1].value else { return nil }

            language = lang
            contents = data
        }

        let open: [UInt8]
        if let lang = language {
            open = Array([
                [60, 112, 114, 101, 62, 60, 99, 111, 100, 101, 32, 99, 108, 97, 115, 115, 61, 34],
                self.languagePrefix, lang, [34, 62]
            ].joined())
        } else {
            open = [60, 112, 114, 101, 62, 60, 99, 111, 100, 101, 62]
        }

        let result = [open, contents, [10, 60, 47, 99, 111, 100, 101, 62, 60, 47, 112, 114, 101, 62]]

        return .init(Array(result.joined()))
    }
}

