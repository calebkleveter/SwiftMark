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
    
    public init() {}
    
    let tokenGenerators: [(regex: String, templates: [String], tokenGenerator: ([String])throws -> Token?)] = [
        ("\\\\(.)", ["$1"], { return .escape($0[0].safetyHTMLEncoded())}),
        ("( {4}|\\t)(.+)[\\n\\r]?", ["$2"], { return .codeBlock($0[0].safetyHTMLEncoded())}),
        ("\\#{6}\\s?([^#\n]+)\\s?\\#*", ["$1"], {return .header6(try Lexer().tokenize($0[0].safetyHTMLEncoded()))}),
        ("\\#{5}\\s?([^#\n]+)\\s?\\#*", ["$1"], { return .header5(try Lexer().tokenize($0[0].safetyHTMLEncoded()))}),
        ("\\#{4}\\s?([^#\n]+)\\s?\\#*", ["$1"], { return .header4(try Lexer().tokenize($0[0].safetyHTMLEncoded()))}),
        ("\\#{3}\\s?([^#\n]+)\\s?\\#*", ["$1"], { return .header3(try Lexer().tokenize($0[0].safetyHTMLEncoded()))}),
        ("(\\#{2}\\s?([^\\#\n]+)\\#*|(.+)\\n\\-{2,})", ["$2", "$3"], { return .header2(try Lexer().tokenize($0[0].safetyHTMLEncoded()))}),
        ("(\\#\\s?([^\\#\\n]+)\\#*|(.+)\\n\\=+)", ["$2", "$3"], { return .header1(try Lexer().tokenize($0[0].safetyHTMLEncoded()))}),
        ("(\\_{2}|\\*{2})(.+)(\\_{2}|\\*{2})", ["$2"], {return .bold(try Lexer().tokenize($0[0].safetyHTMLEncoded()))}),
        ("(((\\-|\\_|\\*)\\s?){3,})[\\r\\n]", [], { _ in return .horizontalRule}),
        ("(\\_|\\*)([^\\_\\*]+)(\\_|\\*)", ["$2"], { return .italic(try Lexer().tokenize($0[0].safetyHTMLEncoded()))}),
        ("\\!\\[(.+)\\]\\((.+)\\)",  ["$1", "$2"], { return .image(text: $0[0].safetyHTMLEncoded(), url: $0[1])}),
        ("\\[(.+)\\]\\((.+)\\)", ["$1", "$2"], { return .link(text: try Lexer().tokenize($0[0].safetyHTMLEncoded()), url: $0[1])}),
        ("\\>\\s?([^\\n\\>]+)", ["$1"], { return .blockQuote(try Lexer().tokenize($0[0]))}),
        ("(\\+|\\-|\\*)\\s?(.+)", ["$2"], { return .unOrderedList(try Lexer().tokenize($0[0].safetyHTMLEncoded()))}),
        ("\\d+\\.\\s?([^\\n]+)", ["$1"], { return .orderedList(try Lexer().tokenize($0[0].safetyHTMLEncoded()))}),
        ("\\`(.*)\\`", ["$1"], { return .code($0[0].safetyHTMLEncoded())}),
        ("\n{2}", [], { _ in return .break }),
        ("([^\\s]+)", ["$1"], { return .text($0[0].safetyHTMLEncoded())})
        
    ]
    
    public func tokenize(_ string: String)throws -> [Token] {
        var tokens: [Token] = []
        var input = string
        
        while input.characters.count > 0 {
            var matched = false
            
            for (regex, template, generator) in tokenGenerators {
                if let regexMatch = try input.match(regex: regex, with: template) {
                    if let token = try generator(regexMatch.0) {
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
    
    public enum Token {
        case header1([Token])
        case header2([Token])
        case header3([Token])
        case header4([Token])
        case header5([Token])
        case header6([Token])
        case bold([Token])
        case italic([Token])
        case link(text: [Token], url: String)
        case image(text: String, url: String)
        case blockQuote([Token])
        case orderedList([Token])
        case unOrderedList([Token])
        case codeBlock(String)
        case horizontalRule
        case code(String)
        case escape(String)
        case text(String)
        case `break`
        
        public var html: String {
            switch self {
            case .header1(let tokens): return "<h1>\(tokens.map({return $0.html}).joined(separator: " "))</h1>"
            case .header2(let tokens): return "<h2>\(tokens.map({return $0.html}).joined(separator: " "))</h2>"
            case .header3(let tokens): return "<h3>\(tokens.map({return $0.html}).joined(separator: " "))</h3>"
            case .header4(let tokens): return "<h4>\(tokens.map({return $0.html}).joined(separator: " "))</h4>"
            case .header5(let tokens): return "<h5>\(tokens.map({return $0.html}).joined(separator: " "))</h5>"
            case .header6(let tokens): return "<h6>\(tokens.map({return $0.html}).joined(separator: " "))</h6>"
            case .bold(let tokens): return "<strong>\(tokens.map({return $0.html}).joined(separator: " "))</strong>"
            case .italic(let tokens): return "<em>\(tokens.map({return $0.html}).joined(separator: " "))</em>"
            case .link(text: let tokens, url: let url): return "<a href=\"\(url)\">\(tokens.map({return $0.html}).joined(separator: " "))</a>"
            case .image(text: let string, url: let url): return "<img src=\"\(url)\" alt=\"\(string)\">"
            case .blockQuote(let tokens): return "<p>\(tokens.map({return $0.html}).joined(separator: " "))</p>"
            case .orderedList(let tokens): return "<li>\(tokens.map({return $0.html}).joined(separator: " "))</li>"
            case .unOrderedList(let tokens): return "<li>\(tokens.map({return $0.html}).joined(separator: " "))</li>"
            case .codeBlock(let string): return string
            case .horizontalRule: return "<hr />"
            case .code(let string): return "<code>\(string)</code>"
            case .escape(let string): return string
            case .text(let string): return string
            case .break: return "<br>"
            }
        }
        
        public var text: String {
            switch self {
            case .header1(let tokens): return tokens.map({return $0.text}).joined(separator: " ")
            case .header2(let tokens): return tokens.map({return $0.text}).joined(separator: " ")
            case .header3(let tokens): return tokens.map({return $0.text}).joined(separator: " ")
            case .header4(let tokens): return tokens.map({return $0.text}).joined(separator: " ")
            case .header5(let tokens): return tokens.map({return $0.text}).joined(separator: " ")
            case .header6(let tokens): return tokens.map({return $0.text}).joined(separator: " ")
            case .bold(let tokens): return "<strong>\(tokens.map({return $0.text}).joined(separator: " "))</strong>"
            case .italic(let tokens): return "<em>\(tokens.map({return $0.text}).joined(separator: " "))</em>"
            case .link(text: let tokens, url: let url): return "<a href=\"\(url)\">\(tokens.map({return $0.text}).joined(separator: " "))</a>"
            case .image(_, _): return ""
            case .blockQuote(let tokens): return tokens.map({return $0.text}).joined(separator: " ")
            case .orderedList(let tokens): return tokens.map({return $0.text}).joined(separator: " ")
            case .unOrderedList(let tokens): return tokens.map({return $0.text}).joined(separator: " ")
            case .codeBlock(let string): return string
            case .horizontalRule: return ""
            case .code(let string): return "<code>\(string)</code>"
            case .escape(let string): return string
            case .text(let string): return string
            case .break: return ""
            }
        }
        
    }
}
