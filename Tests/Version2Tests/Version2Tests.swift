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
    
    func testATXHeading() {
        let md = """
        # foo
        ## foo
        ### foo
        #### foo
        ##### foo
        ###### foo

        ####### foo

        #5 bolt

        #hashtag

        \\## foo
        
        # foo *bar* \\*baz\\*
        
        #                  foo\u{0020}\u{0020}\u{0020}\u{0020}\u{0020}\u{0020}\u{0020}\u{0020}\u{0020}\u{0020}\u{0020}\u{0020}\u{0020}\u{0020}
        
         ### foo
          ## foo
           # foo
        
            # foo
        
        foo
            # bar
        
        ## foo ##
          ###   bar    ###
        
        # foo ##################################
        ##### foo ##
        
        ### foo ###\u{0020}\u{0020}\u{0020}\u{0020}\u{0020}
        
        ### foo ### b
        
        # foo#
        
        ### foo \\###
        ## foo #\\##
        # foo \\#
        
        ****
        ## foo
        ****
        
        Foo bar
        # baz
        Bar foo
        
        ##\u{0020}
        #\u{0020}
        ### ###
        """
        
        let html = """
        <h1>foo</h1>
        <h2>foo</h2>
        <h3>foo</h3>
        <h4>foo</h4>
        <h5>foo</h5>
        <h6>foo</h6>

        ####### foo

        #5 bolt

        #hashtag

        \\## foo

        <h1>foo *bar* \\*baz\\*</h1>
        
        <h1>foo</h1>
        
        <h3>foo</h3>
        <h2>foo</h2>
        <h1>foo</h1>
        
            # foo
        
        foo
            # bar
        
        <h2>foo</h2>
        <h3>bar</h3>
        
        <h1>foo</h1>
        <h5>foo</h5>
        
        <h3>foo</h3>
        
        <h3>foo ### b</h3>
        
        <h1>foo#</h1>
        
        <h3>foo \\###</h3>
        <h2>foo \\###</h2>
        <h1>foo \\#</h1>
        
        <hr />
        <h2>foo</h2>
        <hr />
        
        Foo bar
        <h1>baz</h1>
        Bar foo
        
        <h2></h2>
        <h1></h1>
        <h3></h3>
        """
        
        test(markdown: md, isEqualTo: html)
    }
    
    static var allTests : [(String, (SwiftMarkTests) -> () throws -> Void)] {
        return [
            ("testThematicBreak", testThematicBreak),
            ("testATXHeading", testATXHeading)
        ]
    }
}

