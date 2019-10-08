import Utilities
import XCTest
import Lexer

/// Test file: https://daringfireball.net/projects/markdown/syntax.text
final class LexerTests: XCTestCase {
    let lexer = Lexer(generators: .default)

    let markdown = { () -> [UInt8] in
        let currentDir = FileManager.default.currentDirectoryPath
        return try! Array(String(contentsOfFile: "\(currentDir)/Tests/markdown_test.md").utf8)
    }()
    
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
