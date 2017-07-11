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
import Parser
import Renderer

public typealias Markdown = MarkdownRenderer

/// Renders Markdown to HTML
open class MarkdownRenderer {
    
    /// Renders Markdown to HTML.
    ///
    /// - Parameter string: The Markdown that will be rendered
    /// - Returns: HTML created from the string passed in.
    /// - Throws: Any errors thrown when creating the RegEx to find the Markdown patterns in the string passed in, or errors while parsing.
    public func render(_ string: String)throws -> String {
        let lexer = Lexer()
        let tokens = try lexer.tokenize(string)
        
        let parser = Parser(tokens: tokens)
        let ast = try parser.parseTokens()
        
        let renderer = Renderer(ast: ast)
        return try renderer.renderAST()
    }
}
