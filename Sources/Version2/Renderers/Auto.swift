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

public class Auto: SyntaxRenderer {
    public var pattern: RegEx = ""
    public var templates: [String] = []
    public var renderer: TextRenderer
    
    public required init(renderer: TextRenderer) {
        self.renderer = renderer
    }
    
    public func tokenize(_ strings: [String], forMatch match: String) throws -> Token {
        return .null(metadata: (rendererName: "Auto", rendererType: .inline, other: [:]))
    }
    
    public func parse()throws -> Node {
        guard case let Token.string(value: value, metadata: metadata) = renderer.currentToken else {
            throw ParserError.incompatibleToken(renderer: "Auto", actualToken: renderer.currentToken)
        }
        renderer.popCurrent()
        return .string(value: value, metadata: metadata)
    }
    
    public func render(_ node: Node)throws -> String {
        guard case let Node.string(value: value, metadata: _) = node else {
            throw RendererError.incompatibleNode(renderer: "Auto", actualNode: node)
        }
        return value
    }
}

