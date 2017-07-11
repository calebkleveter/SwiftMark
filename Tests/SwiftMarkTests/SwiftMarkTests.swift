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
    
    static var allTests : [(String, (SwiftMarkTests) -> () throws -> Void)] {
        return [
                ("TestImageRender", testImageRender),
                ("TestLinkRender", testLinkRender),
                ("TestParagraph", testParagraph)
        ]
    }
}
