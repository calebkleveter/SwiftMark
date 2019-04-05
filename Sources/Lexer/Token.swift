import Foundation
import Utilities

public protocol TokenGenerator {
    func run(on tracker: inout CollectionTracker<[UInt8]>) -> [Lexer.Token]?
}

public struct MarkdownSymbolGenerator: TokenGenerator {
    internal let tokenMap: [UInt8: Lexer.Token]
    
    public init() {
        self.tokenMap = [
            33: Lexer.Token(name: "!"), 35: Lexer.Token(name: "#"), 40: Lexer.Token(name: "("),
            41: Lexer.Token(name: ")"), 42: Lexer.Token(name: "*"), 43: Lexer.Token(name: "+"),
            45: Lexer.Token(name: "-"), 61: Lexer.Token(name: "="), 62: Lexer.Token(name: ">"),
            91: Lexer.Token(name: "["), 92: Lexer.Token(name: "\\"), 93: Lexer.Token(name: "]"),
            96: Lexer.Token(name: "`"),
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
        self.characters = [48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 88, 89, 90]
    }
    
    public func run(on tracker: inout CollectionTracker<[UInt8]>) -> [Lexer.Token]? {
        let data = tracker.read(while: self.characters.contains)
        guard data.count > 0 else { return nil }
        return [.init(name: "raw", data: Array(data))]
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
