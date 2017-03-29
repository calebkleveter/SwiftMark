import XCTest
@testable import SwiftMark

func multiLine(_ string: String...) -> String {
    return string.joined(separator: "\n")
}

class SwiftMarkTests: XCTestCase {
    
    let renderer = MarkdownRenderer()
    
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
        
        let text = "\\![UIWebKit Icon](https://raw.githubusercontent.com/calebkleveter/UIWebKit/develop/icons/uiwebkit-icon-slim-sized.png)\nHello!\nGood `day`\nThis is an ![UIWebKit Icon](https://raw.githubusercontent.com/calebkleveter/UIWebKit/develop/icons/uiwebkit-icon-slim-sized.png)\n## Oh my!\nGoogle Eyes\n-----------\n\nThis has **bold** and _italic_ text"
        let html = "<p>!<a href=\"https://raw.githubusercontent.com/calebkleveter/UIWebKit/develop/icons/uiwebkit-icon-slim-sized.png\">UIWebKit Icon</a></p><p>Hello!</p><p>Good <code>day</code></p><p>This is an </p><img src=\"https://raw.githubusercontent.com/calebkleveter/UIWebKit/develop/icons/uiwebkit-icon-slim-sized.png\" alt=\"UIWebKit Icon\"><br/><h2>Oh my!</h2><br/><h2>Google Eyes</h2><br/><br/><p>This has <strong>bold</strong> and <em>italic</em> text</p>"
        do {
            let renderedText = try renderer.render(text)
            XCTAssertEqual(renderedText, html)
        } catch { XCTFail() }
    }
    
    func testCodeRendering() {
        
        
        let codeBlock = "    class Bold {\n        func goWhereNoneHaveGoneBefore() {\n            print(\"I'm lost!\")\n        }\n    }"
        let headerCode = "    # Jon Skeet"
        
        let codeHtml = "<pre><code>class Bold &#123;\n    func goWhereNoneHaveGoneBefore&#40;&#41; &#123;\n        print&#40;&quot;I'm lost!&quot;&#41;\n    &#125;\n&#125;\n</code></pre>"
        let headerHtml = "<pre><code># Jon Skeet\n</code></pre>"
        
        XCTAssert(try renderer.render(codeBlock) == codeHtml, try! renderer.render(codeBlock))
        XCTAssert(try renderer.render(headerCode) == headerHtml, try! renderer.render(headerCode))
    }
    
    func testUnOrderedLists() {
        
        let md = "+ HHHHHHHHH\n- GGGGGGGGGG\n* dskfjhdsfjkdf"
        let html = "<ul><li>HHHHHHHHH</li><li>GGGGGGGGGG</li><li>dskfjhdsfjkdf</li></ul>"
        XCTAssert(try renderer.render(md) == html, try! renderer.render(md))
    }
    
    func testOrderedList() {
        
        let md = "1. HHHHHHHHH\n2. GGGGGGGGGG\n3. dskfjhdsfjkdf"
        let html = "<ol><li>HHHHHHHHH</li><li>GGGGGGGGGG</li><li>dskfjhdsfjkdf</li></ol>"
        XCTAssert(try renderer.render(md) == html, try! renderer.render(md))
    }
    
    func testBlockQuote() {
        
        let md = "> HHHHHHHHH\n> GGGGGGGGGG\n> dskfjhdsfjkdf"
        let html = "<blockquote><p>HHHHHHHHH</p><p>GGGGGGGGGG</p><p>dskfjhdsfjkdf</p></blockquote>"
        XCTAssert(try renderer.render(md) == html, try! renderer.render(md))
    }
    
    static var allTests : [(String, (SwiftMarkTests) -> () throws -> Void)] {
        return [
            ("Test Regex Match", testRegexMatch),
            ("Test Markdown Rendering", testMarkdownRenderer),
            ("Test Code Block Rendering", testCodeRendering),
            ("Test Unordered List", testUnOrderedLists),
            ("Test Ordered List", testOrderedList),
            ("Test Block Quotes", testBlockQuote)
        ]
    }
}
