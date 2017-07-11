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

extension Character {
    
    /// Tests a character to see if it could be involved in an HTML tag.
    ///
    /// - Returns: A bool denoting whether the the character is a '>', '<', '/', '(', ')', '"', '{', or '}'.
    func isDangerousAscii() -> Bool {
        if self == "<" || self == ">" || self == "/" || self == "(" || self == ")" || self == "{" || self == "}" || self == "\"" { return true }
        return false
    }
}

extension String {
    
    /// Encodes a string to pervent direct HTML injection to a web page.
    ///
    /// - Returns: The encoded string.
    public func safetyHTMLEncoded() -> String {
        let htmlAsciiCodes: [String: String] = ["<": "&lt;", ">": "&gt;", "/": "&#47;", "(": "&#40;", ")": "&#41;", "{": "&#123;", "}": "&#125;", "\"": "&quot;"]
        var finalString = ""
        _ = self.characters.map {
            if $0.isDangerousAscii() {
                finalString.append(htmlAsciiCodes[String($0)]!)
            } else { finalString.append(String($0)) }
        }
        return finalString
    }
}
