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

/// A token containing the data for an HTML element that was taken from Markdown.
public enum Token {
    
    /// A token without any extra data.
    case null(metadata: Metadata)
    
    /// A token with data stored as a String.
    case string(value: String, metadata: Metadata)
    
    /// Returns that metadata for the current `Token`.
    public var metadata: Metadata {
        switch self {
        case let .null(metadata: metadata): return metadata
        case let .string(value: _, metadata: metadata): return metadata
        }
    }
    
    /// Returns the value contained in the `.string` case. Returns `nil` for the `.null` case.
    public var value: String? {
        switch self {
        case .null: return nil
        case let .string(value: val, metadata: _): return val
        }
    }
}
