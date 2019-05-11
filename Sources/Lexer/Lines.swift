import Utilities

extension CollectionTracker where Base == Array<Lexer.Token> {
    public func atStartOfLine() -> Bool {
        let last = self.peek(back: 1)
        return last.first?.name == .newLine || last == []
    }
}
