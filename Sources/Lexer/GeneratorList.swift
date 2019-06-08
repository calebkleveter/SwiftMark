import Utilities

extension HandlerList where Handler == TokenGenerator {
    public static var `default`: HandlerList<TokenGenerator> {
        return HandlerList<TokenGenerator>(handlers: [
            MarkdownSymbolGenerator(),
            AlphaNumericGenerator(),
            WhitespaceGenerator(),
            NewLineGenerator(),
            EscapedGenerator()
        ], default: DefaultGenerator())
    }
}
