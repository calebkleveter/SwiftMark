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
import Lexer

open class Parser {
    
    public init() {}
    
    public func parse(_ tokens: [Lexer.Token]) -> String {
        var paragraph = ""
        var orderedList = ""
        var unOrderedList = ""
        var blockQuote = ""
        var codeBlock = ""
        var html = ""
        
        func clearParagraph() {
            if paragraph != "" {
                html.append("<p>\(paragraph)</p>")
                paragraph = ""
            }
        }
        
        func clearQuote() {
            if blockQuote != "" {
                html.append("<blockquote>\(blockQuote)</blockquote>")
                blockQuote = ""
            }
        }
        
        func clearList() {
            if orderedList != "" {
                html.append("<ol>\(orderedList)</ol>")
                orderedList = ""
            }
        }
        
        func clearUnorderedList() {
            if unOrderedList != "" {
                html.append("<ul>\(unOrderedList)</ul>")
                unOrderedList = ""
            }
        }
        
        func clearCode() {
            if codeBlock != "" {
                html.append("<pre><code>\(codeBlock)</code></pre>")
                codeBlock = ""
            }
        }
        
        for token in tokens {
            switch token {
            case .escape(let escapedString): paragraph.append(escapedString)
            case .text(let textString):
                clearList()
                clearUnorderedList()
                clearQuote()
                clearCode()
                if textString == "\r\n" {
                    clearParagraph()
                } else {
                    paragraph.append(textString)
                }
            case .code(_): paragraph.append(token.html)
            case .link(_): paragraph.append(token.html)
            case .bold(_): paragraph.append(token.html)
            case .italic(_): paragraph.append(token.html)
                
            case .codeBlock(let code):
                clearParagraph()
                clearList()
                clearUnorderedList()
                clearQuote()
                codeBlock.append(code + "\n")
                
            case .blockQuote(_):
                clearParagraph()
                clearList()
                clearUnorderedList()
                clearCode()
                blockQuote.append(token.html)
                
            case .orderedList(_):
                clearParagraph()
                clearCode()
                clearUnorderedList()
                clearQuote()
                orderedList.append(token.html)
                
            case .unOrderedList(_):
                clearParagraph()
                clearCode()
                clearList()
                clearQuote()
                unOrderedList.append(token.html)
                
            default:
                clearParagraph()
                clearList()
                clearUnorderedList()
                clearQuote()
                clearCode()
                html.append(token.html)
            }
        }
        clearParagraph()
        clearList()
        clearUnorderedList()
        clearQuote()
        clearCode()
        return html
    }
    
    public func parseUnstyled(tokens: [Lexer.Token]) -> String {
        return "<p>\(tokens.map({return $0.text}).joined(separator: " "))</p>"
    }
}
