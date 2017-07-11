import XCTest
@testable import SwiftMark

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
    
    func testImageRender() {
        let md = "![Deployment Target Dropdown in Xcode](http://i.stack.imgur.com/HSiIL.png)"
        let html = "<img src=\"http://i.stack.imgur.com/HSiIL.png\" alt=\"Deployment Target Dropdown in Xcode\"/>"
        test(markdown: md, isEqualTo: html)
    }
    
    func testLinkRender() {
        var md = "[Stack Overflow](https://stackoverflow.com/)"
        var html = "<a href=\"https://stackoverflow.com/\">Stack Overflow</a>"
        test(markdown: md, isEqualTo: html)
        
        md = "[What does `code` do in an *italic* link and not **bold**?](https://stackoverflow.com/)"
        html = "<a href=\"https://stackoverflow.com/\">What does <code>code</code> do in an <em>italic</em> link and not <strong>bold</strong>?</a>"
        test(markdown: md, isEqualTo: html)
    }
    
    func testParagraph() {
        var md = "If your iOS version is lower then the Xcode version on the other hand, you can change the deployment target for a lower version of iOS by going to the General Settings and under Deployment set your Deployment Target:"
        var html = "<p>If your iOS version is lower then the Xcode version on the other hand, you can change the deployment target for a lower version of iOS by going to the General Settings and under Deployment set your Deployment Target:</p>"
        test(markdown: md, isEqualTo: html)
        
        md = """
        Xcode 7.0.1 and iOS 9.1 are incompatible. You will need to update your version of Xcode via the Mac app store.
        
        If your iOS version is lower then the Xcode version on the other hand, you can change the deployment target for a lower version of iOS by going to the General Settings and under Deployment set your Deployment Target:
        """
        
        html = "<p>Xcode 7.0.1 and iOS 9.1 are incompatible. You will need to update your version of Xcode via the Mac app store.</p><br/><p>If your iOS version is lower then the Xcode version on the other hand, you can change the deployment target for a lower version of iOS by going to the General Settings and under Deployment set your Deployment Target:</p>"
        test(markdown: md, isEqualTo: html)
        
        md = """
        Xcode `7.0.1` and iOS `9.1` are *incompatible*. You will need to **update your version of Xcode** via the Mac app store.
        
        If your iOS version is lower then the Xcode version on the other hand, you can change the deployment target for a lower version of iOS by going to the **General Settings** and under Deployment set your *Deployment Target*:
        """
        
        html = "<p>Xcode <code>7.0.1</code> and iOS <code>9.1</code> are <em>incompatible</em>. You will need to <strong>update your version of Xcode</strong> via the Mac app store.</p><br/><p>If your iOS version is lower then the Xcode version on the other hand, you can change the deployment target for a lower version of iOS by going to the <strong>General Settings</strong> and under Deployment set your <em>Deployment Target</em>:</p>"
        test(markdown: md, isEqualTo: html)
    }
    
    func testCodeBlock() {
        var md = """
        ```
        class Person {
            let name: String

            init(name: String) {
                self.name = name
            }
        }
        ```
        """
        
        var html =
        "<pre><code>\n" +
        """
        class Person {
            let name: String

            init(name: String) {
                self.name = name
            }
        }
        """.safetyHTMLEncoded() + "\n</code></pre>"
        test(markdown: md, isEqualTo: html)
        
        md = """
        ```
        Hello *World*!
        Great day **isn't* it?
        ```
        """
        
        html =
        "<pre><code>\n" +
        """
        Hello *World*!
        Great day **isn't* it?
        """.safetyHTMLEncoded() + "\n</code></pre>"
        test(markdown: md, isEqualTo: html)
    }
    
    func testHeaders() {
        let md = """
        # Header 1
        Plain text goes here
        #### header 4

        HEader2
        -----

        More plain text here
        Another line under it

        Header with a **bold *italic***
        =======

        ### Header 3
        ##### Header 5
        ###### Header 6

        # Header 1
        """
        
        let html = "<h1>Header 1</h1><p>Plain text goes here</p><h4>header 4</h4><br/><h2>HEader2</h2><br/><p>More plain text here</p><p>Another line under it</p><br/><h1>Header with a <strong>bold <em>italic</em></strong></h1><br/><h3>Header 3</h3><h5>Header 5</h5><h6>Header 6</h6><br/><h1>Header 1</h1>"
        
        test(markdown: md, isEqualTo: html)
    }
    
    static var allTests : [(String, (SwiftMarkTests) -> () throws -> Void)] {
        return [
                ("TestImageRender", testImageRender),
                ("TestLinkRender", testLinkRender),
                ("TestParagraph", testParagraph),
                ("TestCodeBlock", testCodeBlock),
                ("TestHeaders", testHeaders)
        ]
    }
}
