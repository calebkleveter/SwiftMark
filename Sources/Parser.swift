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
    
    enum ParserLevel {
        case high
        case low
    }
    
    enum ParserType {
        case normal
        case styled
    }
    
    func parse(_ tokens: [Lexer.Token], level: ParserLevel, type: ParserType) -> String {
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
                if textString == "\r\n" || textString == "\\r\\n" || textString == "\r" || textString == "\n" {
                    clearParagraph()
                } else {
                    switch level {
                    case .high: paragraph.append(textString)
                    case .low:
                        switch type {
                        case .normal: paragraph.append(textString)
                        case .styled: html.append(textString)
                        }
                    }
                }
            case .code(_): paragraph.append(token.html)
            case .link(let text, let href): paragraph.append("<a href=\"\(href)\">\(parse(text, level: .low, type: .styled))</a>")
            case .bold(let text): paragraph.append("<strong>\(parse(text, level: .low, type: .styled))</strong>")
            case .italic(let text): paragraph.append("<em>\(parse(text, level: .low, type: .styled))</em>")
                
            case .codeBlock(let code):
                clearParagraph()
                clearList()
                clearUnorderedList()
                clearQuote()
                codeBlock.append(code + "\n")
                
            case .blockQuote(let quoteLine):
                clearParagraph()
                clearList()
                clearUnorderedList()
                clearCode()
                blockQuote.append(parse(quoteLine, level: .low, type: .normal))
                
            case .orderedList(let listItem):
                clearParagraph()
                clearCode()
                clearUnorderedList()
                clearQuote()
                orderedList.append("<li>\(parse(listItem, level: .low, type: .normal))</li>")
                
            case .unOrderedList(let listItem):
                clearParagraph()
                clearCode()
                clearList()
                clearQuote()
                unOrderedList.append("<li>\(parse(listItem, level: .low, type: .normal))</li>")
                
            case .header1(let text):
                clearParagraph()
                clearList()
                clearUnorderedList()
                clearQuote()
                clearCode()
                html.append("<h1>\(parse(text, level: .low, type: .normal))</h1>")
                
            case .header2(let text):
                clearParagraph()
                clearList()
                clearUnorderedList()
                clearQuote()
                clearCode()
                html.append("<h2>\(parse(text, level: .low, type: .normal))</h2>")
                
            case .header3(let text):
                clearParagraph()
                clearList()
                clearUnorderedList()
                clearQuote()
                clearCode()
                html.append("<h3>\(parse(text, level: .low, type: .normal))</h3>")
                
            case .header4(let text):
                clearParagraph()
                clearList()
                clearUnorderedList()
                clearQuote()
                clearCode()
                html.append("<h4>\(parse(text, level: .low, type: .normal))</h4>")
                
            case .header5(let text):
                clearParagraph()
                clearList()
                clearUnorderedList()
                clearQuote()
                clearCode()
                html.append("<h5>\(parse(text, level: .low, type: .normal))</h5>")
                
            case .header6(let text):
                clearParagraph()
                clearList()
                clearUnorderedList()
                clearQuote()
                clearCode()
                html.append("<h6>\(parse(text, level: .low, type: .normal))</h6>")
                
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
    
}
