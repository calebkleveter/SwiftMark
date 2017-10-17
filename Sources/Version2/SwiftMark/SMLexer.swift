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

extension Markdown: Lexer {
    public func tokenize(_ string: String)throws -> [Token] {
        var input = string
        var tokens: [Token] = []
        
        while input.count > 0 {
            var matched = false
            
            for generator in self.syntaxRenderers {
                if generator.pattern == "" { continue }
                if let match = try input.match(regex: generator.pattern, with: generator.templates) {
                    let token = try generator.tokenize(match.0, forMatch: match.1)
                    input = String(describing: input[match.1.endIndex...])
                    
                    tokens.append(token)
                    matched = true
                    break
                }
            }
            
            if !matched {
                let index = input.characters.index(input.startIndex, offsetBy: 1)
                let autoMetadata: Metadata = (rendererName: "Auto", rendererType: .inline, other: [:])
                
                tokens.append(.string(value: String(describing: input[..<index]), metadata: autoMetadata))
                input = String(describing: input[index...])
            }
        }
        
        return tokens
    }
}
