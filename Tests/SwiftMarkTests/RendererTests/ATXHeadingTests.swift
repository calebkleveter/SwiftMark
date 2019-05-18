import SwiftMark
import XCTest

final class ATXHeadingTests: XCTestCase {
    let renderer = SwiftMark(config: Config(renderers: [], default: ATXHeading()))

    func testDepth() throws {
        let text = """
        #
        ##
        ###
        ####
        #####
        ######
        """

        let bytes = try self.renderer.render(markdown: Array(text.utf8))
        let html = String(decoding: bytes, as: UTF8.self)

        XCTAssertEqual(html, "<h1></h1><h2></h2><h3></h3><h4></h4><h5></h5><h6></h6>")
    }

    func testSuffix() throws {
        let text = """
        # ###
        # #
        ### #
        ## ##
        #### ######
        """

        let bytes = try self.renderer.render(markdown: Array(text.utf8))
        let html = String(decoding: bytes, as: UTF8.self)

        XCTAssertEqual(html, "<h1></h1><h1></h1><h3></h3><h2></h2><h4></h4>")
    }
}

