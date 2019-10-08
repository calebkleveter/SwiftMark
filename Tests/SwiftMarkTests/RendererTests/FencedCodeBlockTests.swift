import SwiftMark
import XCTest

final class FencedCodeBlockTests: XCTestCase {
    let renderer = SwiftMark(config: Config(renderers: [], default: FencedCodeBlock()))

    func testBlock() throws {
        let text = """
        ```
        ## Doc Header
        public struct Foo: Bar {
            private baz: Int = 0

            func farOff() -> Bool {
                // ----
            }
        }
        ```
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

    func testTildeFence() throws {
        let text = """
        ~~~~
        Just some raw text in the code block.
        ~~~
        Don't end just yet.
        ~~~~
        """

        let bytes = try self.renderer.render(markdown: Array(text.utf8))
        let html = String(decoding: bytes, as: UTF8.self)

        XCTAssertEqual(html, """
        <pre><code>Just some raw text in the code block.
        ~~~
        Don't end just yet.
        </code></pre>
        """)
    }

    func testInfoString() throws {
        let text = """
        ```swift
        public struct Foo: Bar {
            private baz: Int = 0
        }
        ```
        """

        let bytes = try self.renderer.render(markdown: Array(text.utf8))
        let html = String(decoding: bytes, as: UTF8.self)

        XCTAssertEqual(html, """
        <pre><code class="language-swift">public struct Foo: Bar {
            private baz: Int = 0
        }
        </code></pre>
        """)
    }

    func testIndentedBlock() throws {
        let text = """
          ```
          ## Doc Header
        public struct Foo: Bar {
            private baz: Int = 0

            func farOff() -> Bool {
                // ----
            }
          }
          ```
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
