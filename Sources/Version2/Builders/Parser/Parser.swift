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

/// A Parser for parsing an array of `Token`s to an AST (made up of `Node`s).
public protocol Parser {
    
    /// The tokens that will be parsed into an AST.
    var tokens: [Token] { get }
    
    /// Returns the index of the next `Token` to parse.
    var currentTokenIndex: Int { get set }
    
    /// Returns the `Token` at the `currentTokenIndex`.
    var currentToken: Token { get }
    
    /// Returns a `Bool` with wheather there are more `Token`s to parse.
    var tokensAvailable: Bool { get }
    
    /// Returns the current `Token` and removes it from the stack.
    @discardableResult func popCurrent() -> Token
    
    /// Parses the tokens in the stack to an AST made of `Node`s.
    func parseTokens()throws -> [Node]
}

/// An artaficial `Parser` to the `parser` property to in the `SyntaxRenderer.init(renderer: Renderer)` method.
public class MockParser: Parser {
    public var tokens: [Token] = []
    public var currentTokenIndex: Int = 0
    public var currentToken: Token = .string(value: "", metadata: (rendererName: "", rendererType: .inline, other: [:]))
    public var tokensAvailable: Bool = false
    public required init(tokens: [Token]) {}
    public func popCurrent() -> Token { return currentToken }
    public func parseTokens() -> [Node] { return [] }
}
