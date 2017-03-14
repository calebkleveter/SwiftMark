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

open class Lexer {
    
    let tokenGenerators: [(regex: String, templates: [String], tokenGenerator: ([String]) -> Token?)] = [
        ("\\\\(.)", ["$1"], { return .escape($0[0].safetyHTMLEncoded())}),
        ("\\s{4}([^\\n]+)", ["$1"], { return .codeBlock($0[0].safetyHTMLEncoded())}),
        ("\\#{6}\\s?([^#\n]+)\\s?\\#*", ["$1"], { return .header6($0[0].safetyHTMLEncoded())}),
        ("\\#{5}\\s?([^#\n]+)\\s?\\#*", ["$1"], { return .header5($0[0].safetyHTMLEncoded())}),
        ("\\#{4}\\s?([^#\n]+)\\s?\\#*", ["$1"], { return .header4($0[0].safetyHTMLEncoded())}),
        ("\\#{3}\\s?([^#\n]+)\\s?\\#*", ["$1"], { return .header3($0[0].safetyHTMLEncoded())}),
        ("(\\#{2}\\s?([^\\#\n]+)\\#*|(.+)\\n\\-{2,})", ["$2", "$3"], { return .header2($0[0].safetyHTMLEncoded())}),
        ("(\\#\\s?([^\\#]+)\\#*|(.+)\\n\\=+)", ["$2", "$3"], { return .header1($0[0].safetyHTMLEncoded())}),
        ("(\\_{2}|\\*{2})([^\\_\\*]+)(\\_{2}|\\*{2})", ["$2"], {return .bold($0[0].safetyHTMLEncoded())}),
        ("(\\_|\\*)([^\\_\\*]+)(\\_|\\*)", ["$2"], { return .italic($0[0].safetyHTMLEncoded())}),
        ("\\!\\[(.+)\\]\\((.+)\\)",  ["$1", "$2"], { return .image(text: $0[0].safetyHTMLEncoded(), url: $0[1])}),
        ("\\[(.+)\\]\\((.+)\\)", ["$1", "$2"], { return .link(text: $0[0].safetyHTMLEncoded(), url: $0[1])}),
        ("\\>\\s?([^\\n\\>]+)", ["$1"], { return .blockQuote($0[0])}),
        ("(\\+|\\-|\\*)\\s?([^\\n(\\+|\\-|\\*)]+)", ["$2"], { return .unOrderedList($0[0].safetyHTMLEncoded())}),
        ("\\d\\.\\s?([^\\n]+)", ["$1"], { return .orderedList($0[0].safetyHTMLEncoded())}),
        ("((\\-|\\_|\\*)[\\s]?){3,}", [], { _ in return .horizontalRule}),
        ("\\`(.*)\\`", ["$1"], { return .code($0[0].safetyHTMLEncoded())}),
        ("([^\\s]+)", ["$1"], { return .text($0[0].safetyHTMLEncoded())})
        
    ]
    
    func tokenize(_ string: String)throws -> [Token] {
        var tokens: [Token] = []
        var input = string
        
        while input.characters.count > 0 {
            var matched = false
            
            for (regex, template, generator) in tokenGenerators {
                if let regexMatch = try input.match(regex: regex, with: template) {
                    if let token = generator(regexMatch.0) {
                        tokens.append(token)
                    }
                    input = input.substring(from: input.characters.index(input.startIndex, offsetBy: regexMatch.1.characters.count))
                    matched = true
                    break
                    
                }
            }
            if !matched {
                let index = input.characters.index(input.startIndex, offsetBy: 1)
                tokens.append(.text(input.substring(to: index)))
                input = input.substring(from: index)
            }
        }
        return tokens
    }
    
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
        case blockQuote(String)
        case orderedList(String)
        case unOrderedList(String)
        case codeBlock(String)
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
            case .blockQuote(let string): return "<p>\(string)</p>"
            case .orderedList(let string): return "<li>\(string)</li>"
            case .unOrderedList(let string): return "<li>\(string)</li>"
            case .codeBlock(let string): return string
            case .horizontalRule: return "<hr />"
            case .code(let string): return "<code>\(string)</code>"
            case .escape(let string): return string
            case .text(let string): return string
            }
        }

    }
}
