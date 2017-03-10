import XCTest
@testable import SwiftDown

class SwiftDownTests: XCTestCase {
    func testRegexMatch() {
        do {
           let match = try "![UIWebKit Icon](https://raw.githubusercontent.com/calebkleveter/UIWebKit/develop/icons/uiwebkit-icon-slim-sized.png)".match(regex: "\\!\\[(.+)\\]\\((.+)\\)", with: ["$1", "$2"])
            if let match = match {
                let expectedResult = (["UIWebKit Icon", "https://raw.githubusercontent.com/calebkleveter/UIWebKit/develop/icons/uiwebkit-icon-slim-sized.png"], "![UIWebKit Icon](https://raw.githubusercontent.com/calebkleveter/UIWebKit/develop/icons/uiwebkit-icon-slim-sized.png)")
                XCTAssertEqual(expectedResult.0, match.0)
                XCTAssertEqual(expectedResult.1, match.1)
            } else { XCTFail() }
        } catch {
            XCTFail()
        }
    }
    
    func testMarkdownRenderer() {
        let renderer = MarkdownRenderer()
        let text = "\\![UIWebKit Icon](https://raw.githubusercontent.com/calebkleveter/UIWebKit/develop/icons/uiwebkit-icon-slim-sized.png)\nHello!\nGood `day`\nThis is an ![UIWebKit Icon](https://raw.githubusercontent.com/calebkleveter/UIWebKit/develop/icons/uiwebkit-icon-slim-sized.png)\n## Oh my!\nGoogle Eyes\n-----------\n\nThis has **bold** and _italic_ text"
        let html = "<p>!<a href=\"https://raw.githubusercontent.com/calebkleveter/UIWebKit/develop/icons/uiwebkit-icon-slim-sized.png\">UIWebKit Icon</a></p><p>Hello!</p><p>Good <code>day</code></p><p>This is an </p><img src=\"https://raw.githubusercontent.com/calebkleveter/UIWebKit/develop/icons/uiwebkit-icon-slim-sized.png\" alt=\"UIWebKit Icon\"><br/><h2>Oh my!</h2><br/><h2>Google Eyes</h2><br/><br/><p>This has <strong>bold</strong> and <em>italic</em> text</p>"
        do {
            let renderedText = try renderer.render(text)
            XCTAssertEqual(renderedText, html)
        } catch { XCTFail() }
    }
    
    
    
    static var allTests : [(String, (SwiftDownTests) -> () throws -> Void)] {
        return [
            ("Test Regex Match", testRegexMatch),
            ("Test Markdown Rendering", testMarkdownRenderer)
        ]
    }
}
