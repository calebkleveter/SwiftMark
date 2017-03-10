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

import Foundation

var expressions: [String: NSRegularExpression] = [:]

public extension String {
    public func match(regex: String, with templates: [String])throws -> ([String], String)? {
        let expression: NSRegularExpression
        if let regExp = expressions[regex] { expression = regExp } else {
            expression = try NSRegularExpression(pattern: "^\(regex)", options: [])
            expressions[regex] = expression
        }
        
        let matchRange = expression.rangeOfFirstMatch(in: self, options: [], range: NSMakeRange(0, self.utf16.count))
        if matchRange.location == NSNotFound {
            return nil
        }
        var matchString = (self as NSString).substring(with: matchRange)
        var regexCaptures: [String] = []
        var fullMatch = ""
        for match in expression.matches(in: matchString, options: .withoutAnchoringBounds, range: NSMakeRange(0, matchString.utf16.count)) {
            for temp in templates {
                let text = expression.replacementString(for: match, in: matchString, offset: 0, template: temp)
                if text != "" { regexCaptures.append(text) }
                
            }
            fullMatch = expression.replacementString(for: match, in: matchString, offset: 0, template: "$0")
        }
        return (regexCaptures, fullMatch)
    }
}
