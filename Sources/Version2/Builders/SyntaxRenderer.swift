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

/// Specefies wheather a renderer is for inline syntax, leaf block, or a container block.
public enum SyntaxRendererType {
    
    /// Designates a `SyntaxRenderer` is for rendering a leaf block (https://github.github.com/gfm/#leaf-blocks)
    case leafBlock
    
    /// Designates a `SyntaxRenderer` is for rendering a container block (https://github.github.com/gfm/#container-blocks)
    case containerBlock
    
    /// Designates a `SyntaxRenderer` is for rendering inline markdown (https://github.github.com/gfm/#inlines)
    case inline
}

/// Encompasses all the required methods and preperties required to render a syntax element to a different syntax element (i.e. Markdown to HTML.)
public protocol SyntaxRenderer: TokenGenerator, TokenParser, NodeRenderer {}
