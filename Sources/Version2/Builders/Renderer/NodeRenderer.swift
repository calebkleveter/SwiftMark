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

/// Renders a single `Node` of an AST to a `String`.
public protocol NodeRenderer {
    
    /// The `Renderer` that is running the `NodeRenderer`.
    var renderer: TextRenderer { get }
    
    
    /// Creates a `NodeRenderer` with the parent `Renderer`.
    ///
    /// - Parameter renderer: The `Renderer  that is running the `NodeRenderer`.
    init(renderer: TextRenderer)
    
    /// Renders an AST `Node` to a `String`.
    ///
    /// - Parameter node: The `Node` to render.
    /// - Returns: The text from the `Node` passed in.
    func render(_ node: Node) -> String
}
