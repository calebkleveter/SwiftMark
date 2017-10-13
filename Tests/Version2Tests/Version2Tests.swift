import XCTest
@testable import Version2

class SwiftMarkTests: XCTestCase {
    let markdown = Markdown()
    
    func test(markdown md: String, isEqualTo html: String) {
        do {
            let renderedMd = try markdown.render(md)
            XCTAssertEqual(html, renderedMd)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    static var allTests : [(String, (SwiftMarkTests) -> () throws -> Void)] {
        return [
        ]
    }
}

