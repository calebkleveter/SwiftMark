public struct Document<Data> where Data: Collection & Equatable {
    public var lines: [Line]
    
    public init(lines: [Line] = []) {
        self.lines = lines
    }
    
    public enum Line: Equatable {
        case blank
        case line(CollectionTracker<Data>, Ending)
        
        public enum Ending: String {
            case newLine = "\u{000A}"
            case carriageReturn = "\u{000D}"
            case combined = "\u{000A}\u{000D}"
            case eof = "EOF"
        }
    }
}
