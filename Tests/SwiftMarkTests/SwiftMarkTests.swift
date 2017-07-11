import XCTest
@testable import SwiftMark

class SwiftMarkTests: XCTestCase {
    let markdown = Markdown()
    
    func testImageRender() {
        let md = "![Deployment Target Dropdown in Xcode](http://i.stack.imgur.com/HSiIL.png)"
        let html = "<img src=\"http://i.stack.imgur.com/HSiIL.png\" alt=\"Deployment Target Dropdown in Xcode\"/>"
        do {
            let renderedMd = try markdown.render(md)
            XCTAssertEqual(html, renderedMd)
        } catch {
            XCTFail(error.localizedDescription)
        }
        
    }
    
    static var allTests : [(String, (SwiftMarkTests) -> () throws -> Void)] {
        return [
                ("TestImageRender", testImageRender)
        ]
    }
}
