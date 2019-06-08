import SwiftMark
import XCTest

final class BlankLineTests: XCTestCase {
    let renderer = SwiftMark(config: .init(renderers: [], default: BlankLine()))

    func testBlankLines() throws {
        let text = """
        \u{0020}\u{0020}\u{0020}\u{0020}

        \u{0020}\u{0009}

        \u{0009}\u{0009}\u{0020}
        \u{000B}\u{000C}
        """

        let result = try self.renderer.render(markdown: Array(text.utf8))

        XCTAssertEqual(result, [])
    }
}
