import XCTest
@testable import SwiftMark

class SwiftMarkTests: XCTestCase {
    let markdown = Markdown()
    
    func test(markdown md: String, isEqualTo html: String) {
        do {
            let renderedMd = try markdown.render(md)
            XCTAssertEqual(html, renderedMd)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testImageRender() {
        let md = "![Deployment Target Dropdown in Xcode](http://i.stack.imgur.com/HSiIL.png)"
        let html = "<img src=\"http://i.stack.imgur.com/HSiIL.png\" alt=\"Deployment Target Dropdown in Xcode\"/>"
        test(markdown: md, isEqualTo: html)
    }
    
    func testLinkRender() {
        var md = "[Stack Overflow](https://stackoverflow.com/)"
        var html = "<a href=\"https://stackoverflow.com/\">Stack Overflow</a>"
        test(markdown: md, isEqualTo: html)
        
        md = "[What does `code` do in an *italic* link?](https://stackoverflow.com/)"
        html = "<a href=\"https://stackoverflow.com/\">What does <code>code</code> do in an <em>italic</em> link?</a>"
        test(markdown: md, isEqualTo: html)
    }
    
    static var allTests : [(String, (SwiftMarkTests) -> () throws -> Void)] {
        return [
                ("TestImageRender", testImageRender),
                ("TestLinkRender", testLinkRender)
        ]
    }
}
