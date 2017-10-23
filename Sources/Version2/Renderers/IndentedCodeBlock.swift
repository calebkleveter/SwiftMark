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
        guard let code = strings.first else {
            throw LexerError.missingTemplateValue(renderer: "IndentedCodeBlock")
        }
        
        return .string(value: code, metadata: (rendererName: "IndentedCodeBlock", rendererType: .leafBlock, fullMatch: match, other: [:]))
    }
    
    public func parse() throws -> Node {
        return .null(metadata: (rendererName: "IndentedCodeBlock", rendererType: .leafBlock, fullMatch: "match", other: [:]))
    }
    
    public func render(_ node: Node) throws -> String {
        return ""
    }
    
    
}