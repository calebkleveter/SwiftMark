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
        <pre><code>***
        </code></pre>
        Foo
        <pre><code>***
        </code></pre>
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
        
        <pre><code># foo
        </code></pre>
        
        foo
        <pre><code># bar
        </code></pre>
        
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
    
    func testIndentedCodeBlock() {
        let md = """
            a simple
              indented code block

          - foo

            bar

        1.  foo

            - bar

            <a/>
            *hi*

            - one

            chunk1

            chunk2
          
         
         
            chunk3

            chunk1
              
              chunk2

        Foo
            bar

            foo
        bar

        # Heading
            foo
        Heading
        ------
            foo
        ----

            foo
        bar


            
            foo
            
            foo
        """
        
        let html = """
        <pre><code>a simple
          indented code block
        </code></pre>

        <ul>
        <li>
        <p>foo</p>
        <p>bar</p>
        </li>
        </ul>

        <ol>
        <li>
        <p>foo</p>
        <ul>
        <li>bar</li>
        </ul>
        </li>
        </ol>

        <pre><code>&lt;a/&gt;
        *hi*

        - one
        </code></pre>

        <pre><code>chunk1

        chunk2



        chunk3
        </code></pre>

        <pre><code>chunk1
          
          chunk2
        </code></pre>

        <p>Foo
        bar</p>
        
        <pre><code>foo
        </code></pre>
        <p>bar</p>

        <h1>Heading</h1>
        <pre><code>foo
        </code></pre>
        <h2>Heading</h2>
        <pre><code>foo
        </code></pre>
        <hr />

        <pre><code>    foo
        bar
        </code></pre>

        <pre><code>foo
        </code></pre>

        <pre><code>foo
        </code></pre>
        """
        
        test(markdown: md, isEqualTo: html)
    }
    
    func testFencedCodeBlock() {
        let md = """
        ```
        <
        >
        ```

        ~~~
        <
         >
        ~~~

        ``
        foo
        ``

        ```
        aaa
        ~~~
        ```

        ~~~
        aaa
        ```
        ~~~

        ````
        aaa
        ```
        ``````

        ~~~~
        aaa
        ~~~
        ~~~~

        ```

        ```

        \u{0020}\u{0020}
        ```

          
        ```

         ```
         aaa
        aaa
        ```

          ```
        aaa
          aaa
        aaa
          ```

           ```
           aaa
            aaa
          aaa
           ```

            ```
            aaa
            ```

        ```
        aaa
          ```

           ```
        aaa
          ```

        ```
        aaa
            ```

        ``` ```
        aaa

        ~~~~~~
        aaa
        ~~~ ~~

        foo
        ```
        bar
        ```
        baz

        foo
        ---
        ~~~
        bar
        ~~~
        # baz

        ```ruby
        def foo(x)
          return 3
        end
        ```

        ~~~~    ruby startline=3 $%@#$
        def foo(x)
          return 3
        end
        ~~~~~~~

        ````;
        ````

        ``` aa ```
        foo

        ```
        ``` aaa
        ```
        """
        
        let html = """
        <pre><code>&lt;
         &gt;
        </code></pre>

        <pre><code>&lt;
         &gt;
        </code></pre>

        <p><code>foo</code></p>

        <pre><code>aaa
        ~~~
        </code></pre>

        <pre><code>aaa
        ```
        </code></pre>

        <pre><code>aaa
        ```
        </code></pre>

        <pre><code>aaa
        ~~~
        </code></pre>

        <pre><code></code></pre>

        <pre><code></code></pre>

        <blockquote>
        <pre><code>aaa
        </code></pre>
        </blockquote>
        <p>bbb</p>

        <pre><code>
          
        </code></pre>

        <pre><code></code></pre>

        <pre><code>aaa
        aaa
        </code></pre>

        <pre><code>aaa
        aaa
        aaa
        </code></pre>

        <pre><code>aaa
         aaa
        aaa
        </code></pre>

        <pre><code>```
        aaa
        ```
        </code></pre>

        <pre><code>aaa
        </code></pre>

        <pre><code>aaa
        </code></pre>

        <pre><code>aaa
            ```
        </code></pre>

        <p><code></code>
        aaa</p>

        <pre><code>aaa
        ~~~ ~~
        </code></pre>

        <p>foo</p>
        <pre><code>bar
        </code></pre>
        <p>baz</p>

        <h2>foo</h2>
        <pre><code>bar
        </code></pre>
        <h1>baz</h1>

        <pre><code class="language-ruby">def foo(x)
          return 3
        end
        </code></pre>

        <pre><code class="language-ruby">def foo(x)
          return 3
        end
        </code></pre>

        <pre><code class="language-;"></code></pre>

        <p><code>aa</code>
        foo</p>

        <pre><code>``` aaa
        </code></pre>
        """
        
        test(markdown: md, isEqualTo: html)
    }
    
    func testBackslashEscape() {
        let md = """
        \\!\\\"\\#\\$\\%\\&\\'\\(\\)\\*\\+\\,\\-\\.\\/\\:\\;\\<\\=\\>\\?\\@\\[\\]\\^\\_\\`\\{\\|\\}\\~\\\\b\\\\
        
        \\→\\A\\a\\ \\3\\φ\\«
        
        \\*not emphasized*
        \\<br/> not a tag
        \\[not a link](/foo)
        \\`not code`
        1\\. not a list
        \\* not a list
        \\# not a heading
        \\[foo]: /url \"not a reference\"
        
        \\\\*emphasis*
        
        foo\\
        bar
        
        `` \\[\\` ``
        
            \\[\\]
        
        ~~~
        \\[\\]
        ~~~
        
        <http://example.com?find=\\*>
        
        <a href=\"/bar\\/)\">
        
        [foo](/bar\\* \"ti\\*tle\")
        
        [foo]
        
        [foo]: /bar\\* \"ti\\*tle\"
        
        ``` foo\\+bar
        foo
        ```
        """
        
        let html = """
        <p>!&quot;#$%&amp;'()*+,-./:;&lt;=&gt;?@[\\]^_`{|}~</p>
        
        <p>\\→\\A\\a\\ \\3\\φ\\«</p>
        
        <p>*not emphasized*
        &lt;br/&gt; not a tag
        [not a link](/foo)
        `not code`
        1. not a list
        * not a list
        # not a heading
        [foo]: /url &quot;not a reference&quot;</p>
        
        <p>\\<em>emphasis</em></p>
        
        <p>foo<br />
        bar</p>
        
        <p><code>\\[\\`</code></p>
        
        <pre><code>\\[\\]
        </code></pre>
        
        <pre><code>\\[\\]
        </code></pre>
        
        <p><a href=\"http://example.com?find=%5C*\">http://example.com?find=\\*</a></p>
        
        <a href=\"/bar\\/)\">
        
        <p><a href=\"/bar*\" title=\"ti*tle\">foo</a></p>
        
        <p><a href=\"/bar*\" title=\"ti*tle\">foo</a></p>
        
        <pre><code class=\"language-foo+bar\">foo
        </code></pre>
        """
        
        test(markdown: md, isEqualTo: html)
    }
    
    func testCodeSpan() {
        let md = """
        `foo`

        `` foo ` bar  ``

        ` `` `

        ``
        foo
        ``

        `foo   bar
          baz`

        `a\u{00a0}\u{00a0}b`

        `foo `` bar`

        `foo\`bar`
        
        *foo`*`
        
        [not a `link](/foo`)
        
        `<a href=\"`\">`
        
        <a href=\"`\">`
        
        `<http://foo.bar.`baz>`
        
        <http://foo.bar.`baz>`
        
        ```foo``
        
        `foo
        
        `foo``bar``
        """
        
        let html = """
        <p><code>foo</code></p>

        <p><code>foo ` bar</code></p>

        <p><code>``</code></p>

        <p><code>foo</code></p>

        <p><code>foo bar baz</code></p>

        <p><code>foo `` bar</code></p>

        <p><code>foo\</code>bar`</p>
        
        <p>*foo<code>*</code></p>
        
        <p>[not a <code>link](/foo</code>)</p>
        
        <p><code>&lt;a href=&quot;</code>&quot;&gt;`</p>
        
        <p><a href=\"`\">`</p>
        
        <p><code>&lt;http://foo.bar.</code>baz&gt;`</p>
        
        <p><a href=\"http://foo.bar.%60baz\">http://foo.bar.`baz</a>`</p>
        
        <p>```foo``</p>
        
        <p>`foo</p>
        
        <p>`foo<code>bar</code></p>
        """
        
        test(markdown: md, isEqualTo: html)
    }
    
    static var allTests : [(String, (SwiftMarkTests) -> () throws -> Void)] {
        return [
            ("testThematicBreak", testThematicBreak),
            ("testATXHeading", testATXHeading),
            ("testIndentedCodeBlock", testIndentedCodeBlock),
            ("testFencedCodeBlock", testFencedCodeBlock),
            ("testBackslashEscape", testBackslashEscape),
            ("testCodeSpan", testCodeSpan)
        ]
    }
}

