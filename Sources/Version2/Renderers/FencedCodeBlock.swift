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

public class FencedCodeBlock: SyntaxRenderer {
    public var pattern: RegEx = " {0,3}(`{3,}|~{3,}) *(\\w*)?(\n.*?)? {0,3}((`{3,}|~{3,})|$)"
    public var templates: [String] = ["$3", "$2"]
    public var renderer: TextRenderer
    
    public required init(renderer: TextRenderer) {
        self.renderer = renderer
    }
    
    public func tokenize(_ strings: [String], forMatch match: String) throws -> Token {
        let code = strings.first ?? ""
        var language: String {
            if strings.count < 2 {
                return ""
            } else {
                return strings.last!
            }
        }
        
        return .string(value: code, metadata: (rendererName: "FencedCodeBlock", rendererType: .leafBlock, fullMatch: match, other: ["language": language]))
    }
    
    public func parse() throws -> Node {
        defer { renderer.popCurrent() }
        guard case let Token.string(value: value, metadata: metadata) = renderer.currentToken else {
            throw ParserError.incompatibleToken(renderer: "FencedCodeBlock", actualToken: renderer.currentToken)
        }
        let newMetadata: Metadata = (rendererName: "FencedCodeBlock", rendererType: .leafBlock, fullMatch: metadata.fullMatch, other: ["language": metadata.other["language"] ?? ""])
        
        return .string(value: value, metadata: newMetadata)
    }
    
    public func render(_ node: Node) throws -> String {
        return ""
    }
}
