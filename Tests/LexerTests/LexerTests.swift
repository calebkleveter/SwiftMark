import Utilities
import XCTest
import Lexer

/// Test file: https://daringfireball.net/projects/markdown/syntax.text
final class LexerTests: XCTestCase {
    let lexer = Lexer(generators: [MarkdownSymbolGenerator(), AlphaNumericGenerator()], defaultGenerator: DefaultGenerator())
    let markdown = { () -> [UInt8] in
        let url = URL(string: "https://daringfireball.net/projects/markdown/syntax.text")!
        return try! Array(Data(contentsOf: url))
    }()
    
    func testLines() {
        let rawLines = self.markdown.split(separator: 10, maxSplits: Int.max, omittingEmptySubsequences: false)
        let lineCount = rawLines.count
        let lines = lexer.lines(for: self.markdown)
        
//        XCTAssertEqual(lines.count, lineCount)
        
        let header: [UInt8] = [77, 97, 114, 107, 100, 111, 119, 110, 58, 32, 83, 121, 110, 116, 97, 120]
        XCTAssertEqual(lines.first, Lexer.Line.line(CollectionTracker(header), .newLine))
        XCTAssertEqual(lines.last, Lexer.Line.blank)
        
        measure {
            for _ in 0...10_000 {
                _ = lexer.lines(for: self.markdown)
            }
        }
    }
    
    func testLex() throws {
        let tokens = try self.lexer.lex(string: self.markdown)
        print(tokens[...35])
    }
}
