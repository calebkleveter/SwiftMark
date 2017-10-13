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

public class Markdown {
    var generators: [TokenGenerator] = []
    var parsers: [TokenParser] = []
    
    let renderer = SMRenderer()
    
    public func addParsers(_ newParsers: TokenParser...) {
        self.parsers.append(contentsOf: newParsers)
    }
    
    public func addRenderers(_ renderers: NodeRenderer.Type...) {
        self.renderer.addRenderers(renderers)
    }
    
    public func render(_ string: String)throws -> String {
        let input = string.replacingOccurrences(of: "\u{0000}", with: "\u{FFFD}")
        parserTokens = try self.tokenize(input)
        let ast = self.parseTokens()
        return renderer.render(ast)
    }
}
