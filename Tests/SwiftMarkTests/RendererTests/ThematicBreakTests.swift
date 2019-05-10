import SwiftMark
import XCTest

final class ThematicBreakTests: XCTestCase {
    let renderer = SwiftMark(config: Config(renderers: [], default: ThematicBreak()))

    func testHyphen() throws {
        let text = """
        ----------------
        ---
           ----
        -- -- -- --     -    -    ----- -   --
        """

        let bytes = try self.renderer.render(markdown: Array(text.utf8))
        let html = String(decoding: bytes, as: UTF8.self)

        XCTAssertEqual(html, "<hr/><hr/><hr/><hr/>")
    }
}
