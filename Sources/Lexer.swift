//The MIT License (MIT)
//
//Copyright (c) 2017 Caleb Kleveter
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

import Foundation

class Lexer {
    enum Token {
        case header1(String)
        case header2(String)
        case header3(String)
        case header4(String)
        case header5(String)
        case header6(String)
        case bold(String)
        case italic(String)
        case link(text: String, url: String)
        case image(text: String, url: String)
        case blockQuote([String])
        case orderedList([String])
        case unOrderedList([String])
        case codeBlock([String])
        case horizontalRule
        case code(String)
        case escape(String)
        case text(String)
        
        var html: String {
            switch self {
            case .header1(let string): return "<h1>\(string)</h1>"
            case .header2(let string): return "<h2>\(string)</h2>"
            case .header3(let string): return "<h3>\(string)</h3>"
            case .header4(let string): return "<h4>\(string)</h4>"
            case .header5(let string): return "<h5>\(string)</h5>"
            case .header6(let string): return "<h6>\(string)</h6>"
            case .bold(let string): return "<strong>\(string)</strong>"
            case .italic(let string): return "<em>\(string)</em>"
            case .link(text: let string, url: let url): return "<a href=\"\(url)\">\(string)</a>"
            case .image(text: let string, url: let url): return "<img src=\"\(url)\" alt=\"\(string)\">"
            case .blockQuote(let strings):
                let paragraphes = strings.map({ return "<p>\($0)</p>" }).joined()
                return "<blockquote>\(paragraphes)</blockquote>"
            case .orderedList(let strings):
                let listItems = strings.map({ return "<li>\($0)</li>" }).joined()
                return "<ol>\(listItems)</ol>"
            case .unOrderedList(let strings):
                let listItems = strings.map({ return "<li>\($0)</li>" }).joined()
                return "<ul>\(listItems)</ul>"
            case .codeBlock(let strings):
                let lines = strings.map({ return "\($0)\n" }).joined()
                return "<pre><code>\(lines)</code></pre>"
            case .horizontalRule: return "<hr />"
            case .code(let string): return "<code>\(string)</code>"
            case .escape(let string): return string
            case .text(let string): return string
            }
        }

    }
}
