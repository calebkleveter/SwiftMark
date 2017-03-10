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

class Parser {
    func parse(_ tokens: [Lexer.Token]) -> String {
        var paragraph = ""
        var html = ""
        
        for token in tokens {
            switch token {
            case .escape(let escapedString): paragraph.append(escapedString)
            case .text(let textString):
                if textString == "\n" {
                    if paragraph != "" {
                        html.append("<p>\(paragraph)</p>")
                        paragraph = ""
                    } else {
                        html.append("<br/>")
                    }
                } else {
                    paragraph.append(textString)
                }
            case .code(let codeString): paragraph.append("<code>\(codeString)</code>")
            case .link(text: let linkText, url: let url): paragraph.append("<a href=\"\(url)\">\(linkText)</a>")
            case .bold(let boldText): paragraph.append("<strong>\(boldText)</strong>")
            case .italic(let italicText): paragraph.append("<em>\(italicText)</em>")
            default:
                if paragraph != "" {
                    html.append("<p>\(paragraph)</p>")
                    paragraph = ""
                }
                html.append(token.html)
            }
        }
        if paragraph != "" {
            html.append("<p>\(paragraph)</p>")
        }
        return html
    }

}
