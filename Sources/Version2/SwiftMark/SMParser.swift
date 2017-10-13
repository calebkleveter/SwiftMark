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

fileprivate var currentIndex: Int = 0
internal var parserTokens: [Token] = []

extension Markdown: Parser {
    
    // MARK: - Properties
    public var tokens: [Token] {
        return parserTokens
    }
    
    public var currentTokenIndex: Int {
        get {
            return currentIndex
        }
        set {
            currentIndex = newValue
        }
    }
    
    public var currentToken: Token {
        return tokens[currentTokenIndex]
    }
    
    public var tokensAvailable: Bool {
        return currentTokenIndex < tokens.count
    }
    
    // MARK: - Methods
    @discardableResult public func popCurrent() -> Token {
        defer { currentTokenIndex += 1 }
        return currentToken
    }
    
    public func parseTokens()throws -> [Node] {
        var nodes: [Node] = []
        
        while tokensAvailable {
            let currentMetadata: Metadata
            switch currentToken {
            case let .null(metadata: metadata): currentMetadata = metadata
            case let .string(value: _, metadata: metadata): currentMetadata = metadata
            }
            
            if let parser = self.syntaxRenderers.filter({ (parser) -> Bool in
                return String.init(describing: parser) == currentMetadata.rendererName
            }).first {
                try nodes.append(parser.parse())
            }
        }
        
        return nodes
    }
}
