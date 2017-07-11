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

import Parser

open class Renderer {
    private let ast: AST
    
    public init(ast: AST) {
        self.ast = ast
    }
    
    public func renderAST()throws -> String {
        return try ast.map(renderNode).joined()
    }
    
    private func renderText(_ node: ParagraphNode, withParagraph: Bool)throws -> String {
        let text = try node.content.map(renderNode).joined()
        if withParagraph {
            return "<p>\(text)</p>"
        } else {
            return "\(text)"
        }
    }
    
    // FIXME: - Get a mop and dry this method up.
    public func renderNode(_ node: ElementNode)throws -> String {
        switch node {
        case let node as TextNode: return node.value
        case let node as HeaderOneNode:
            let text = try node.content.map({ element in
                return try renderText(element as! ParagraphNode, withParagraph: false)
            }).joined()
            return "<h1>\(text)</h1>"
        case let node as HeaderTwoNode:
            let text = try node.content.map({ element in
                return try renderText(element as! ParagraphNode, withParagraph: false)
            }).joined()
            return "<h2>\(text)</h2>"
        case let node as HeaderThreeNode:
            let text = try node.content.map({ element in
                return try renderText(element as! ParagraphNode, withParagraph: false)
            }).joined()
            return "<h3>\(text)</h3>"
        case let node as HeaderFourNode:
            let text = try node.content.map({ element in
                return try renderText(element as! ParagraphNode, withParagraph: false)
            }).joined()
            return "<h4>\(text)</h4>"
        case let node as HeaderFiveNode:
            let text = try node.content.map({ element in
                return try renderText(element as! ParagraphNode, withParagraph: false)
            }).joined()
            return "<h5>\(text)</h5>"
        case let node as HeaderSixNode:
            let text = try node.content.map({ element in
                return try renderText(element as! ParagraphNode, withParagraph: false)
            }).joined()
            return "<h6>\(text)</h6>"
        case let node as BoldNode:
            let text = try node.content.map({ element in
                return try renderText(element as! ParagraphNode, withParagraph: false)
            }).joined()
            return "<strong>\(text)</strong>"
        case let node as ItalicNode:
            let text = try node.content.map({ element in
                return try renderText(element as! ParagraphNode, withParagraph: false)
            }).joined()
            return "<em>\(text)</em>"
        case let node as LinkNode:
            let text = try node.text.map({ element in
                return try renderText(element as! ParagraphNode, withParagraph: false)
            }).joined()
            return "<a href=\"\(node.url)\">\(text)</a>"
        case let node as ImageNode: return "<img src=\"\(node.url)\" alt=\"\(node.text)\"/>"
        case _ as HorizontalRuleNode: return "<hr/>"
        case _ as BreakNode: return "<br/>"
        case let node as CodeNode: return "<code>\(node.value)</code>"
        case let node as ParagraphNode: return "<p>\(try node.content.map(renderNode).joined())</p>"
        case let node as CodeBlockNode: return "<pre><code>\(node.code.joined(separator: "\n"))</code></pre>"
        case let node as OrderedListNode:
            let elements = try node.content.map({ element in
                return "<li>\(try renderText(element as! ParagraphNode, withParagraph: false))</li>"
            }).joined()
            return "<ol>\(elements)</ol>"
        case let node as UnorderedListNode:
            let elements = try node.content.map({ element in
                return "<li>\(try renderText(element as! ParagraphNode, withParagraph: false))</li>"
            }).joined()
            return "<ul>\(elements)</ul>"
        case let node as BlockquoteNode:
            let elements = try node.content.map({return try renderText($0 as! ParagraphNode, withParagraph: true)}).joined()
            return "<blockquote>\(elements)</blockquote>"
        default: fatalError("Unsupported Node")
        }
    }
}
