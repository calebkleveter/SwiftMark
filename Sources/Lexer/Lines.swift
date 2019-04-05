import Utilities

extension Lexer {
    private func line(contents: [UInt8], ending: Lexer.Line.Ending) -> Lexer.Line {
        if contents.count == 0 || contents.drop(while: { $0 == 32 || $0 == 9 }) == [] {
            return .blank
        } else {
            return .line(CollectionTracker(Array(contents)), ending)
        }
    }
    
    public func lines(for string: [UInt8]) -> [Lexer.Line] {
        var lines: [Lexer.Line] = []
        var start = string.startIndex
        var end = string.startIndex
        
        while end < string.endIndex {
            switch string[end] {
            case 10:
                if string.index(after: end) < string.endIndex, string[string.index(after: end)] == 13 {
                    lines.append(self.line(contents: Array(string[start..<end]), ending: .combined))
                    end = string.index(after: end)
                } else {
                    lines.append(self.line(contents: Array(string[start..<end]), ending: .newLine))
                }
                start = string.index(after: end)
                
            case 13:
                lines.append(self.line(contents: Array(string[start..<end]), ending: .carriageReturn))
                start = string.index(after: end)
                
            default: break
            }
            
            end = string.index(after: end)
        }
        
        if start < end {
            lines.append(Lexer.Line.line(CollectionTracker(Array(string[start..<end])), .eof))
        }
        
        return lines
    }
    
    public enum Line: Equatable {
        case blank
        case line(CollectionTracker<[UInt8]>, Ending)
        
        public enum Ending: String {
            case newLine = "\u{000A}"
            case carriageReturn = "\u{000D}"
            case combined = "\u{000A}\u{000D}"
            case eof = "EOF"
        }
    }
}
