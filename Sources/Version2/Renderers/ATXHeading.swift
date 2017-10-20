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

public class ATXHeading: SyntaxRenderer {
    public let pattern: RegEx = " {0,3}#{1,6}( +|(?m:$))"
    public let templates: [String] = []
    public let renderer: TextRenderer
    
    public required init(renderer: TextRenderer) {
        self.renderer = renderer
    }
    
    public func tokenize(_ strings: [String], forMatch match: String) throws -> Token {
        var headerDepth = 0
        
        match.forEach { character in
            if character == "#" {
                headerDepth += 1
            }
        }
        
        return .null(metadata: (rendererName: "ATXHeading", rendererType: .leafBlock, fullMatch: match, other: ["headerDepth": headerDepth]))
    }
    
    public func parse() throws -> Node {
        guard case let Token.null(metadata: (rendererName: _, rendererType: _, fullMatch: match, other: data)) = renderer.popCurrent() else {
            throw ParserError.incompatibleToken(renderer: "ATXHeading", actualToken: renderer.currentToken)
        }
        
        var subnodes: [Node] = []
        
        while renderer.tokensAvailable {
            let metadata: Metadata
            
            switch renderer.currentToken {
            case let .null(metadata: currentMetadata):
                metadata = currentMetadata
            case let .string(value: _, metadata: currentMetadata):
                metadata = currentMetadata
            }
            
            if metadata.rendererType != .inline {
                let node = Node.string(value: metadata.fullMatch, metadata: (rendererName: "Text", rendererType: .inline, fullMatch: metadata.fullMatch, other: [:]))
                subnodes.append(node)
                renderer.popCurrent()
            } else {
                guard let syntaxRenderer = self.renderer.syntaxRenderer(forName: metadata.rendererName) else {
                    throw ParserError.unknownParser(parser: metadata.rendererName)
                }
                let node = try syntaxRenderer.parse()
                subnodes.append(node)
                
                if metadata.rendererName == "EOL" { break }
            }
        }
        
        return Node.array(values: subnodes, metadata: (rendererName: "ATXHeading", rendererType: .leafBlock, fullMatch: match, other: data))
    }
    
    public func render(_ node: Node) throws -> String {
        guard case let Node.array(values: subNodes, metadata: metadata) = node else {
            throw RendererError.incompatibleNode(renderer: "ATXHeading", actualNode: node)
        }
        
        let headerDepth: Int = metadata.other["headerDepth"] as? Int ?? 1
        let subElements: String = try subNodes.map({ (node) -> String in
            guard let syntaxRenderer = self.renderer.syntaxRenderer(forName: metadata.rendererName) else {
                throw RendererError.unknownRenderer(renderer: metadata.rendererName)
            }
            return try syntaxRenderer.render(node)
        }).joined()
        
        return "<h\(headerDepth)>\(subElements)</h\(headerDepth)>"
    }
    
    
}
