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

open class Parser {
    func parse(_ tokens: [Lexer.Token]) -> String {
        var paragraph = ""
        var orderedList = ""
        var unOrderedList = ""
        var blockQuote = ""
        var codeBlock = ""
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
                        if orderedList == "" && unOrderedList == "" && blockQuote == "" {
                            html.append("<br/>")
                        }
                    }
                } else {
                    paragraph.append(textString)
                }
            case .code(let codeString): paragraph.append("<code>\(codeString)</code>")
            case .link(text: let linkText, url: let url): paragraph.append("<a href=\"\(url)\">\(linkText)</a>")
            case .bold(let boldText): paragraph.append("<strong>\(boldText)</strong>")
            case .italic(let italicText): paragraph.append("<em>\(italicText)</em>")
                
            case .codeBlock(let code):
                if paragraph != "" {
                    html.append("<p>\(paragraph)</p>")
                    paragraph = ""
                } else if orderedList != "" {
                    html.append("<ol>\(orderedList)</ol>")
                    orderedList = ""
                } else if unOrderedList != "" {
                    html.append("<ul>\(unOrderedList)</ul>")
                    unOrderedList = ""
                } else if blockQuote != "" {
                    html.append("<blockquote>\(blockQuote)</blockquote>")
                    blockQuote = ""
                }
                codeBlock.append(code + "\n")
                
            case .blockQuote(let quoteLine):
                if paragraph != "" {
                    html.append("<p>\(paragraph)</p>")
                    paragraph = ""
                } else if codeBlock != "" {
                    html.append("<pre><code>\(codeBlock)</code></pre>")
                    codeBlock = ""
                } else if orderedList != "" {
                    html.append("<ol>\(orderedList)</ol>")
                    orderedList = ""
                } else if unOrderedList != "" {
                    html.append("<ul>\(unOrderedList)</ul>")
                    unOrderedList = ""
                }
                blockQuote.append("<p>\(quoteLine)</p>")
                
            case .orderedList(let listItem):
                if paragraph != "" {
                    html.append("<p>\(paragraph)</p>")
                    paragraph = ""
                } else if codeBlock != "" {
                    html.append("<pre><code>\(codeBlock)</code></pre>")
                    codeBlock = ""
                } else if unOrderedList != "" {
                    html.append("<ul>\(unOrderedList)</ul>")
                    unOrderedList = ""
                } else if blockQuote != "" {
                    html.append("<blockquote>\(blockQuote)</blockquote>")
                    blockQuote = ""
                }
                orderedList.append("<li>\(listItem)</li>")
                
            case .unOrderedList(let listItem):
                if paragraph != "" {
                    html.append("<p>\(paragraph)</p>")
                    paragraph = ""
                } else if codeBlock != "" {
                    html.append("<pre><code>\(codeBlock)</code></pre>")
                    codeBlock = ""
                } else if orderedList != "" {
                    html.append("<ol>\(orderedList)</ol>")
                    orderedList = ""
                } else if blockQuote != "" {
                    html.append("<blockquote>\(blockQuote)</blockquote>")
                    blockQuote = ""
                }
                unOrderedList.append("<li>\(listItem)</li>")
                
            default:
                if paragraph != "" {
                    html.append("<p>\(paragraph)</p>")
                    paragraph = ""
                } else if codeBlock != "" {
                    html.append("<pre><code>\(codeBlock)</code></pre>")
                    codeBlock = ""
                } else if orderedList != "" {
                    html.append("<ol>\(orderedList)</ol>")
                    orderedList = ""
                } else if unOrderedList != "" {
                    html.append("<ul>\(unOrderedList)</ul>")
                    unOrderedList = ""
                } else if blockQuote != "" {
                    html.append("<blockquote>\(blockQuote)</blockquote>")
                    blockQuote = ""
                }

                html.append(token.html)
            }
        }
        if paragraph != "" {
            html.append("<p>\(paragraph)</p>")
        }
        if codeBlock != "" {
            html.append("<pre><code>\(codeBlock)</code></pre>")
        }
        if orderedList != "" {
            html.append("<ol>\(orderedList)</ol>")
        }
        if unOrderedList != "" {
            html.append("<ul>\(unOrderedList)</ul>")
        }
        if blockQuote != "" {
            html.append("<blockquote>\(blockQuote)</blockquote>")
        }
        
        return html
    }

}
