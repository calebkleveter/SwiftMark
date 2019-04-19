import Utilities
import XCTest
import Lexer

/// Test file: https://daringfireball.net/projects/markdown/syntax.text
final class LexerTests: XCTestCase {
    let lexer: Lexer = {
        let generators = GeneratorList(generators: [
            MarkdownSymbolGenerator(),
            AlphaNumericGenerator(),
            NewLineGenerator()
        ], default: DefaultGenerator())
        return Lexer(generators: generators)
    }()

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
    
    func testMeasureLex() throws {

        // Baseline: 0.044
        measure {
            do {
                _ = try self.lexer.lex(string: self.markdown)
            } catch let error {
                XCTFail(error.localizedDescription)
            }
        }
    }
}
