import Foundation
import Utilities

public protocol TokenGenerator {
    func run(on tracker: inout CollectionTracker<[UInt8]>) -> [Lexer.Token]?
}

public protocol NewLineGeneratorProtocol: TokenGenerator {
    func ending(for tokens: [Lexer.Token]) -> Document<[Lexer.Token]>.Line.Ending
}

public struct MarkdownSymbolGenerator: TokenGenerator {
    internal let tokenMap: [UInt8: Lexer.Token]
    
    public init() {
        self.tokenMap = [
            "!": Lexer.Token(name: "!"), "#": Lexer.Token(name: "#"), "(": Lexer.Token(name: "("),
            ")": Lexer.Token(name: ")"), "*": Lexer.Token(name: "*"), "+": Lexer.Token(name: "+"),
            "-": Lexer.Token(name: "-"), "=": Lexer.Token(name: "="), ">": Lexer.Token(name: ">"),
            "[": Lexer.Token(name: "["), "\\": Lexer.Token(name: "\\"), "]": Lexer.Token(name: "]"),
            "_": Lexer.Token(name: "_"), "`": Lexer.Token(name: "`"),
        ]
    }
    
    public func run(on tracker: inout CollectionTracker<[UInt8]>) -> [Lexer.Token]? {
        var result: [Lexer.Token] = []
        
        while let character = tracker.peek(), let token = self.tokenMap[character] {
            result.append(token)
            tracker.pop()
        }
        
        return result.count == 0 ? nil : result
    }
}

public struct AlphaNumericGenerator: TokenGenerator {
    let characters: [UInt8]
    
    public init() {
        self.characters = [
            "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l",
            "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H",
            "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "X", "Y", "Z"
        ]
    }
    
    public func run(on tracker: inout CollectionTracker<[UInt8]>) -> [Lexer.Token]? {
        let data = tracker.read(while: self.characters.contains)
        guard data.count > 0 else { return nil }
        return [.init(name: "raw", data: Array(data))]
    }
}

public struct NewLineGenerator: NewLineGeneratorProtocol {
    let newLine: UInt8
    let carriageReturn: UInt8
    
    public init() {
        self.newLine = "\n"
        self.carriageReturn = "\r"
    }
    
    public func run(on tracker: inout CollectionTracker<[UInt8]>) -> [Lexer.Token]? {
        switch tracker.peek() {
        case self.newLine?:
            tracker.pop()
            if tracker.peek() == self.carriageReturn {
                tracker.pop()
                return [Lexer.Token(name: "newLine", data: [self.newLine, self.carriageReturn])]
            } else {
                return [Lexer.Token(name: "newLinw", data: [self.newLine])]
            }
        case self.carriageReturn?: return [Lexer.Token(name: "newLine", data: [self.carriageReturn])]
        default: return nil
        }
    }

    public func ending(for tokens: [Lexer.Token]) -> Document<[Lexer.Token]>.Line.Ending {
        switch tokens.first?.data {
        case .raw([10])?: return .newLine
        case .raw([13])?: return .carriageReturn
        case .raw([13, 10])?: return .combined
        default: return .newLine
        }
    }
}

public struct DefaultGenerator: TokenGenerator {
    public init () { }
    
    public func run(on tracker: inout CollectionTracker<[UInt8]>) -> [Lexer.Token]? {
        guard let character = tracker.read() else { return nil }
        return [.init(name: "raw", data: [character])]
    }
}

extension Lexer {    
    public struct Token: Equatable, CustomStringConvertible {
        public enum Storage: Equatable {
            case raw([UInt8])
            case character
        }
        
        public let name: String
        public let data: Storage
        
        public init(name: String, data: [UInt8]) {
            self.name = name
            self.data = .raw(data)
        }
        
        public init(name: String) {
            self.name = name
            self.data = .character
        }
        
        public var description: String {
            switch self.data {
            case .character: return "Lexer.Token.\(self.name)"
            case let .raw(string): return #"Lexer.Token.raw("\#(String(bytes: string, encoding: .utf8) ?? "null")")"#
            }
        }
    }
}
