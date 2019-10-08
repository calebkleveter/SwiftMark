import SwiftMark
import XCTest

final class IndentedCodeBlockTests: XCTestCase {
    let renderer = SwiftMark(config: Config(renderers: [], default: IndentedCodeBlock()))

    func testBlock() throws {
        let text = """
            ## Doc Header
            public struct Foo: Bar {
                private baz: Int = 0

                func farOff() -> Bool {
                    // ----
                }
            }
        """

        let bytes = try self.renderer.render(markdown: Array(text.utf8))
        let html = String(decoding: bytes, as: UTF8.self)

        XCTAssertEqual(html, """
        <pre><code>## Doc Header
        public struct Foo: Bar {
            private baz: Int = 0

            func farOff() -> Bool {
                // ----
            }
        }
        </code></pre>
        """)
    }
}

