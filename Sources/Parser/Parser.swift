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
    private let tokens: [Lexer.Token]
    private var currentTokenIndex = 0
    
    public init(tokens: [Lexer.Token]) {
        self.tokens = tokens
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
    
    private func parseToken(_ token: Lexer.Token)throws -> ElementNode {
        switch token {
        case .text(_): return parseText()
        case .header1(_): return try parseHeaderOne()
        case .header2(_): return try parseHeaderTwo()
        case .header3(_): return try parseHeaderThree()
        case .header4(_): return try parseHeaderFour()
        case .header5(_): return try parseHeaderFive()
        default: fatalError("Unsupported Token")
        }
    }
    
    // MARK: - Token Parsers
    
    public func parseText() -> ElementNode {
        var text = ""
        
        while true {
            if case let Lexer.Token.text(value) = currentToken {
                popToken()
                text += value
            } else if case let Lexer.Token.escape(value) = currentToken {
                popToken()
                text += value
            } else {
                break
            }
        }
        
        return TextNode(value: text)
    }
    
    public func parseHeaderOne()throws -> ElementNode {
        guard case let Lexer.Token.header1(value) = popToken() else {
            throw ParserError.expectedHeader1
        }
        let content = try value.map(parseToken)
        
        return HeaderOneNode(content: content)
    }
    
    public func parseHeaderTwo()throws -> ElementNode {
        guard case let Lexer.Token.header2(value) = popToken() else {
            throw ParserError.expectedHeader2
        }
        let content = try value.map(parseToken)
        
        return HeaderTwoNode(content: content)
    }
    
    public func parseHeaderThree()throws -> ElementNode {
        guard case let Lexer.Token.header3(value) = popToken() else {
            throw ParserError.expectedHeader3
        }
        let content = try value.map(parseToken)
        
        return HeaderThreeNode(content: content)
    }
    
    public func parseHeaderFour()throws -> ElementNode {
        guard case let Lexer.Token.header3(value) = popToken() else {
            throw ParserError.expectedHeader3
        }
        let content = try value.map(parseToken)
        
        return HeaderThreeNode(content: content)
    }
    
    public func parseHeaderFive()throws -> ElementNode {
        guard case let Lexer.Token.header3(value) = popToken() else {
            throw ParserError.expectedHeader3
        }
        let content = try value.map(parseToken)
        
        return HeaderThreeNode(content: content)
    }
}
