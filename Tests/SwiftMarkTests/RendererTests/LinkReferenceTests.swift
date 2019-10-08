import SwiftMark
import XCTest
import Parser
import Lexer

final class LinkReferenceTests: XCTestCase {
    let parser = Parser(generators: [LinkReference()])
    let lexer = Lexer(generators: .default)

    func testFullLink() throws {
        let text = """
        [Vapor]: <https://vapor.codes/> 'Vapor Website'
        """

        let tokens = try self.lexer.lex(string: Array(text.utf8))
        let ast = try self.parser.parse(tokens: tokens)

        guard let link = ast.metadata["link-Vapor"] as? Link else {
            XCTFail("Expected `link-Vapor` metadata to be a `Link` instance")
            return
        }

        XCTAssertEqual(String(decoding: link.destination, as: UTF8.self), "https://vapor.codes/")
        XCTAssertEqual(link.title.map { String(decoding: $0, as: UTF8.self)}, "Vapor Website")
    }

    func testRelativeLink() throws {
        let text = """
        [Bio]: /about-me
        """

        let tokens = try self.lexer.lex(string: Array(text.utf8))
        let ast = try self.parser.parse(tokens: tokens)

        guard let link = ast.metadata["link-Bio"] as? Link else {
            XCTFail("Expected `link-Bio` metadata to be a `Link` instance")
            return
        }

        XCTAssertEqual(String(decoding: link.destination, as: UTF8.self), "/about-me")
        XCTAssertEqual(link.title, nil)
    }
}
