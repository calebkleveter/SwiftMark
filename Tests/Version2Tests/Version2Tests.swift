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
    
    func testThematicBreak() {
        let md = """
        ***
        ---
        ___
        +++
        ===
        --
        **
        __
         ***
          ***
           ***
            ***
        Foo
            ***
        _____________________________________
         - - -
         **  * ** * ** * **
        -     -      -      -
        - - - -
        _ _ _ _ a

        a------

        ---a---
         *-*
        - foo
        ***
        - bar
        Foo
        ***
        bar
        Foo
        ---
        bar
        * Foo
        * * *
        * Bar
        - Foo
        - * * *
        """
        
        let html = """
        <hr />
        <hr />
        <hr />
        +++
        ===
        --
        **
        __
        <hr />
        <hr />
        <hr />
            ***
        Foo
            ***
        <hr />
        <hr />
        <hr />
        <hr />
        <hr />
        _ _ _ _ a

        a------

        ---a---
         *-*
        - foo
        <hr />
        - bar
        Foo
        ***
        bar
        Foo
        <hr />
        bar
        * Foo
        * * *
        * Bar
        - Foo
        - <hr />
        """
        
        test(markdown: md, isEqualTo: html)
    }
    
    static var allTests : [(String, (SwiftMarkTests) -> () throws -> Void)] {
        return [
            ("testThematicBreak", testThematicBreak)
        ]
    }
}

