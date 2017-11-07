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

public class Markdown: TextRenderer {
    
    public var syntaxRenderers: [SyntaxRenderer] = []
    
    public func addRenderers(_ syntaxRenderers: SyntaxRenderer.Type...) {
        self.syntaxRenderers.append(contentsOf: syntaxRenderers.map({ $0.init(renderer: self) }))
    }
    
    public func syntaxRenderer(forName name: String) -> SyntaxRenderer? {
        let renderer = self.syntaxRenderers.filter({ (renderer) -> Bool in
            let parserName: String
            if let name = String.init(describing: renderer).split(separator: ".").last {
                parserName = String(describing: name)
            } else {
                parserName = String.init(describing: renderer)
            }
            return parserName == name
        }).first
        
        return renderer
    }
    
    public func render(_ string: String)throws -> String {
        self.addRenderers(
                Auto.self,
                EOL.self,
                ThematicBreak.self,
                ATXHeading.self,
                IndentedCodeBlock.self,
                FencedCodeBlock.self,
                CodeSpan.self,
                BackslashEscape.self,
                Text.self
            )
        // https://github.github.com/gfm/#insecure-characters
        let input = string.replacingOccurrences(of: "\u{0000}", with: "\u{FFFD}")
        parserTokens = try self.tokenize(input)
        let ast = try self.parseTokens()
        return try self.render(ast)
    }
}
