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

public typealias AST = [ElementNode]

open class Parser {
    private let tokens: [Lexer.Token]
    private var currentTokenIndex = 0
    
    public init(tokens: [Lexer.Token]) {
        self.tokens = tokens
    }
    
    private var areTokensLeft: Bool {
        return currentTokenIndex < tokens.count
    }
    
    private var currentToken: Lexer.Token {
        return tokens[currentTokenIndex]
    }
    
    @discardableResult
    private func popToken() -> Lexer.Token {
        defer { currentTokenIndex += 1 }
        return currentToken
    }
    
    public func parseCurrentToken()throws -> ElementNode {
        return try parseToken(currentToken)
    }
    
    public func parseTokens()throws -> AST {
        currentTokenIndex = 0
        var nodes: AST = []
        
        while currentTokenIndex < tokens.count {
            let currentNode = try parseCurrentToken()
            nodes.append(currentNode)
        }
        
        return nodes
    }
    
    private func parseToken(_ token: Lexer.Token)throws -> ElementNode {
        switch token {
        case .text(_): return try parseText()
        case .header1(_): return try parseHeaderOne()
        case .header2(_): return try parseHeaderTwo()
        case .header3(_): return try parseHeaderThree()
        case .header4(_): return try parseHeaderFour()
        case .header5(_): return try parseHeaderFive()
        case .header6(_): return try parseHeaderSix()
        case .bold(_): return try parseBold()
        case .italic(_): return try parseItalic()
        case .link(text: _, url: _): return try parseLink()
        case .image(text: _, url: _): return try parseImage()
        case .horizontalRule: return try parseHorizontalRule()
        case .break: return try parseBreak()
        case .code(_): return try parseCode()
        case .blockQuote(_): return try parseBlockquote()
        case .orderedList(_): return try parseOrderedList()
        case .unOrderedList(_): return try parseUnorderedList()
        case .codeBlock(_): return try parseCodeBlock()
        default: fatalError("Unsupported Token: \(token)")
        }
    }
    
    private func stripNewline() {
        if areTokensLeft {
            if case Lexer.Token.text("\n") = currentToken {
                popToken()
            }
        }
    }
    
    // MARK: - Token Parsers
    
    public func parseText()throws -> ElementNode {
        var nodes: [ElementNode] = []
        
        getNodes: while true && areTokensLeft {
            switch currentToken {
            case let .text(value):
                popToken()
                if value == "\r\n" || value == "\n" { break getNodes } else {
                    let node = TextNode(value: value)
                    nodes.append(node)
                }
            case let .escape(value):
                popToken()
                let node = TextNode(value: value)
                nodes.append(node)
            default:
                switch currentToken {
                case .code, .italic, .link, .bold:
                    let node = try parseCurrentToken()
                    nodes.append(node)
                default: break getNodes
                }
            }
        }
        return ParagraphNode(content: nodes)
    }
    
    public func parseHeaderOne()throws -> ElementNode {
        guard case let Lexer.Token.header1(value) = popToken() else {
            throw ParserError.expectedHeader1
        }
        let headerTextParser = Parser(tokens: value)
        let textNodes = try headerTextParser.parseTokens()
        
        stripNewline()
        
        return HeaderOneNode(content: textNodes)
    }
    
    public func parseHeaderTwo()throws -> ElementNode {
        guard case let Lexer.Token.header2(value) = popToken() else {
            throw ParserError.expectedHeader2
        }
        let headerTextParser = Parser(tokens: value)
        let textNodes = try headerTextParser.parseTokens()
        
        stripNewline()
        
        return HeaderTwoNode(content: textNodes)
    }
    
    public func parseHeaderThree()throws -> ElementNode {
        guard case let Lexer.Token.header3(value) = popToken() else {
            throw ParserError.expectedHeader3
        }
        let headerTextParser = Parser(tokens: value)
        let textNodes = try headerTextParser.parseTokens()
        
        stripNewline()
        
        return HeaderThreeNode(content: textNodes)
    }
    
    public func parseHeaderFour()throws -> ElementNode {
        guard case let Lexer.Token.header4(value) = popToken() else {
            throw ParserError.expectedHeader4
        }
        let headerTextParser = Parser(tokens: value)
        let textNodes = try headerTextParser.parseTokens()
        
        stripNewline()
        
        return HeaderFourNode(content: textNodes)
    }
    
    public func parseHeaderFive()throws -> ElementNode {
        guard case let Lexer.Token.header5(value) = popToken() else {
            throw ParserError.expectedHeader5
        }
        let headerTextParser = Parser(tokens: value)
        let textNodes = try headerTextParser.parseTokens()
        
        stripNewline()
        
        return HeaderFiveNode(content: textNodes)
    }
    
    public func parseHeaderSix()throws -> ElementNode {
        guard case let Lexer.Token.header6(value) = popToken() else {
            throw ParserError.expectedHeader6
        }
        let headerTextParser = Parser(tokens: value)
        let textNodes = try headerTextParser.parseTokens()
        
        stripNewline()
        
        return HeaderSixNode(content: textNodes)
    }
    
    public func parseBold()throws -> ElementNode {
        guard case let Lexer.Token.bold(tokens) = popToken() else {
            throw ParserError.expectedBold
        }
        let boldTextParser = Parser(tokens: tokens)
        let textNodes = try boldTextParser.parseTokens()
        
        return BoldNode(content: textNodes)
    }
    
    public func parseItalic()throws -> ElementNode {
        guard case let Lexer.Token.italic(tokens) = popToken() else {
            throw ParserError.expectedItalic
        }
        let italicTextParser = Parser(tokens: tokens)
        let textNodes = try italicTextParser.parseTokens()
        
        return ItalicNode(content: textNodes)
    }
    
    public func parseLink()throws -> ElementNode {
        guard case let Lexer.Token.link(text: text, url: url) = popToken() else {
            throw ParserError.expectedLink
        }
        let linkTextParser = Parser(tokens: text)
        let textNode = try linkTextParser.parseTokens()
        
        return LinkNode(text: textNode, url: url)
    }
    
    public func parseImage()throws -> ElementNode {
        guard case let Lexer.Token.image(text: text, url: url) = popToken() else {
            throw ParserError.expectedImage
        }
        return ImageNode(text: text, url: url)
    }
    
    public func parseHorizontalRule()throws -> ElementNode {
        guard case Lexer.Token.horizontalRule = popToken() else {
            throw ParserError.expectedHorizontalRule
        }
        
        return HorizontalRuleNode()
    }
    
    public func parseBreak()throws -> ElementNode {
        guard case Lexer.Token.break = popToken() else {
            throw ParserError.expectedBreak
        }
        
        return BreakNode()
    }
    
    public func parseCode()throws -> ElementNode {
        guard case let Lexer.Token.code(value) = popToken() else {
            throw ParserError.expectedCode
        }
        return CodeNode(value: value)
    }
    
    public func parseCodeBlock()throws -> ElementNode {
        var codeLines: [String] = []
        
        while true && areTokensLeft {
            if case let Lexer.Token.codeBlock(code) = currentToken {
                popToken()
                codeLines.append(code)
            } else { break }
        }
        
        return CodeBlockNode(code: codeLines)
    }
    
    public func parseBlockquote()throws -> ElementNode {
        var content: [ElementNode] = []
        
        while true {
            if case let Lexer.Token.blockQuote(tokens) = currentToken {
                popToken()
                let nodes = try tokens.map(parseToken)
                content.append(contentsOf: nodes)
            } else {
                break
            }
        }
        
        return BlockquoteNode(content: content)
    }
    
    public func parseOrderedList()throws -> ElementNode {
        var content: [ElementNode] = []
        
        while true {
            if case let Lexer.Token.orderedList(tokens) = currentToken {
                popToken()
                let nodes = try tokens.map(parseToken)
                content.append(contentsOf: nodes)
            } else {
                break
            }
        }
        
        return OrderedListNode(content: content)
    }
    
    public func parseUnorderedList()throws -> ElementNode {
        var content: [ElementNode] = []
        
        while true {
            if case let Lexer.Token.unOrderedList(tokens) = currentToken {
                popToken()
                let nodes = try tokens.map(parseToken)
                content.append(contentsOf: nodes)
            } else {
                break
            }
        }
        
        return UnorderedListNode(content: content)
    }
}
