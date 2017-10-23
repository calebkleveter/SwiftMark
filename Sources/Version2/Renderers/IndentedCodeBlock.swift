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

public class IndentedCodeBlock: SyntaxRenderer {
    public var pattern: RegEx = " {4}(.*)"
    public var templates: [String] = ["$1"]
    public var renderer: TextRenderer
    
    public required init(renderer: TextRenderer) {
        self.renderer = renderer
    }
    
    public func tokenize(_ strings: [String], forMatch match: String) throws -> Token {
        let code = strings.first ?? ""
        return .string(value: code, metadata: (rendererName: "IndentedCodeBlock", rendererType: .leafBlock, fullMatch: match, other: [:]))
    }
    
    public func parse() throws -> Node {
        var codeLines: [Node] = []
        
        while renderer.tokensAvailable {
            let value: String
            let metadata: Metadata
            
            switch renderer.currentToken {
            case let .null(metadata: tokenMetadata):
                value = ""
                metadata = tokenMetadata
            case let .string(value: tokenValue, metadata: tokenMetadata):
                value = tokenValue
                metadata = tokenMetadata
            }
            
            if metadata.rendererName == "IndentedCodeBlock" {
                let node = Node.string(value: value, metadata: (rendererName: "IndentedCodeBlock", rendererType: .leafBlock, fullMatch: "", other: [:]))
                codeLines.append(node)
                renderer.popCurrent()
            } else if metadata.rendererName == "EOL" {
                let node = Node.string(value: "\n", metadata: (rendererName: "IndentedCodeBlock", rendererType: .leafBlock, fullMatch: "", other: [:]))
                codeLines.append(node)
                renderer.popCurrent()
            } else {
                break
            }
        }
        
        return Node.array(values: codeLines, metadata: (rendererName: "IndentedCodeBlock", rendererType: .leafBlock, fullMatch: "", other: [:]))
    }
    
    public func render(_ node: Node) throws -> String {
        guard case let Node.array(values: nodes, metadata: _) = node else {
            throw RendererError.incompatibleNode(renderer: "IndentedCodeBlock", actualNode: node)
        }
        var text = ""
        
        try nodes.forEach { (node) in
            guard case let Node.string(value: value, metadata: _) = node else {
                throw RendererError.incompatibleNode(renderer: "IndentedCodeBlock", actualNode: node)
            }
            text.append(value)
        }
        
        return "<pre><code>\(text)</code></pre>"
    }
    
    
}
