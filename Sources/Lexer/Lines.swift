import Utilities

extension Lexer {
    private func line(contents: String, ending: Lexer.Line.Ending) -> Lexer.Line {
        if contents.count == 0 || contents.trimmingCharacters(in: ["\u{0020}", "\u{0009}"]) == "" {
            return .blank
        } else {
            return .line(CollectionTracker(String(contents)), ending)
        }
    }
    
    public func lines(for string: String) -> [Lexer.Line] {
        var lines: [Lexer.Line] = []
        var start = string.startIndex
        var end = string.startIndex
        
        while end < string.endIndex {
            switch string[end] {
            case "\u{000A}":
                if string.index(after: end) < string.endIndex, string[string.index(after: end)] == "\u{000D}" {
                    lines.append(self.line(contents: String(string[start..<end]), ending: .combined))
                    end = string.index(after: end)
                } else {
                    lines.append(self.line(contents: String(string[start..<end]), ending: .newLine))
                }
                start = string.index(after: end)
                
            case "\u{000D}":
                lines.append(self.line(contents: String(string[start..<end]), ending: .carriageReturn))
                start = string.index(after: end)
                
            default: break
            }
            
            end = string.index(after: end)
        }
        
        if start < end {
            lines.append(Lexer.Line.line(CollectionTracker(String(string[start..<end])), nil))
        }
        
        return lines
    }
    
    public enum Line: Equatable {
        case blank
        case line(CollectionTracker<String>, Ending?)
        
        public enum Ending: String {
            case newLine = "\u{000A}"
            case carriageReturn = "\u{000D}"
            case combined = "\u{000A}\u{000D}"
        }
    }
}
