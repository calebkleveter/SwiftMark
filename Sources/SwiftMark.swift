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

/// Renders Markdown to HTML
open class MarkdownRenderer {
    
    /// The Lexer used to convert the text to tokens so it can parsed.
    public let lexer: Lexer
    
    /// The parser used to cnovert the tokens from the lexer to HTML.
    public let parser: Parser
    
    /// Creates a Markdown renderer with a custom lexer and parser
    ///
    /// - Parameters:
    ///   - lexer: The lexer that will be used during rendering to convert the Markdown to tokens.
    ///   - parser: The parser that will be used during rendering to convert the lexer tokens to HTML.
    public init(with lexer: Lexer, and parser: Parser) {
        self.lexer = lexer
        self.parser = parser
    }
    
    /// Creats a Markdown renderer with a default lexer and parser.
    public convenience init() {
        let newLexer = Lexer()
        let newParser = Parser()
        
        self.init(with: newLexer, and: newParser)
    }
    
    /// Renders Markdown to HTML.
    ///
    /// - Parameter string: The Markdown that will be rendered
    /// - Returns: HTML created from the string passed in.
    /// - Throws: Any errors thrown when creating the RegEx to find the Markdown patterns in the string passed in.
    public func render(_ string: String)throws -> String {
        let tokens = try lexer.tokenize(string)
        return parser.parse(tokens, level: .high, type: .normal)
    }
}
