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

public protocol ElementNode: CustomStringConvertible {}

public struct TextNode: ElementNode {
    public let value: String
    public var description: String {
         return "TextNode(\(value))"
    }
}

public struct HeaderOneNode: ElementNode {
    public let content: [ElementNode]
    public var description: String {
        return "HeaderOneNode(\(content))"
    }
}

public struct HeaderTwoNode: ElementNode {
    public let content: [ElementNode]
    public var description: String {
        return "HeaderTwoNode(\(content))"
    }
}

public struct HeaderThreeNode: ElementNode {
    public let content: [ElementNode]
    public var description: String {
        return "HeaderThreeNode(\(content))"
    }
}

public struct HeaderFourNode: ElementNode {
    public let content: [ElementNode]
    public var description: String {
        return "HeaderFourNode(\(content))"
    }
}

public struct HeaderFiveNode: ElementNode {
    public let content: [ElementNode]
    public var description: String {
        return "HeaderFiveNode(\(content))"
    }
}

public struct HeaderSixNode: ElementNode {
    public let content: [ElementNode]
    public var description: String {
        return "HeaderSixNode(\(content))"
    }
}

public struct BoldNode: ElementNode {
    public let content: [ElementNode]
    public var description: String {
        return "BoldNode(\(content))"
    }
}

public struct ItalicNode: ElementNode {
    public let content: [ElementNode]
    public var description: String {
        return "ItalicNode(\(content))"
    }
}

public struct LinkNode: ElementNode {
    public let text: [ElementNode]
    public let url: String
    public var description: String {
        return "LinkNode(text: \(text), url: \(url))"
    }
}

public struct ImageNode: ElementNode {
    public let text: String
    public let url: String
    public var description: String {
        return "LinkNode(text: \(text), url: \(url))"
    }
}

public struct HorizontalRuleNode: ElementNode {
    public var description: String {
        return "HorizontalRuleNode"
    }
}

public struct CodeNode: ElementNode {
    public let value: String
    public var description: String {
        return "CodeNode(\(value))"
    }
}

public struct ParagraphNode: ElementNode {
    public let content: [ElementNode]
    public var description: String {
        return "ParagraphNode(\(content))"
    }
}

public struct BlockquoteNode: ElementNode {
    public let content: [ElementNode]
    public var description: String {
        return "BlockquoteNode(\(content))"
    }
}

public struct OrderedListNode: ElementNode {
    public let content: [ElementNode]
    public var description: String {
        return "OrderedListNode(\(content))"
    }
}

public struct UnorderedListNode: ElementNode {
    public let content: [ElementNode]
    public var description: String {
        return "UnorderedListNode(\(content))"
    }
}

public struct CodeBlockNode: ElementNode {
    public let code: String
    public var description: String {
        return "CodeBlockNode(\(code))"
    }
    
}
