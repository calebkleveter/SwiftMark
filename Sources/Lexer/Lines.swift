import Utilities

extension CollectionTracker where Base == Array<Lexer.Token> {
    public func atStartOfLine() -> Bool {
        let last = self.peek(back: 1)
        return last.first?.name == .newLine || last == []
    }

    public func whiteSpaceLine() -> (allWhiteSpace: Bool, length: Int) {
        var length = 0

        while self.peek(next: length + 1).last?.data == .raw([32]) {
            length += 1
        }

        let next = self.peek(next: length + 1)
        return (next.count == length || next.last?.name == .newLine, length)
    }
}
