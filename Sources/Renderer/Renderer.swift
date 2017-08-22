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
    
    public func renderNode(_ node: ElementNode)throws -> String {
        switch node {
        case let node as TextNode: return renderText(node: node)
        case let node as HeaderOneNode: return try renderHeaderOne(node: node)
        case let node as HeaderTwoNode: return try renderHeaderTwo(node: node)
        case let node as HeaderThreeNode: return try renderHeaderThree(node: node)
        case let node as HeaderFourNode: return try renderHeaderFour(node: node)
        case let node as HeaderFiveNode: return try renderHeaderFive(node: node)
        case let node as HeaderSixNode: return try renderHeaderSix(node: node)
        case let node as BoldNode: return try renderBold(node: node)
        case let node as ItalicNode: return try renderItalic(node: node)
        case let node as LinkNode: return try renderLink(node: node)
        case let node as ImageNode: return renderImage(node: node)
        case let node as HorizontalRuleNode: return renderHorizontalRule(node: node)
        case let node as BreakNode: return renderBreak(node: node)
        case let node as CodeNode: return renderCode(node: node)
        case let node as ParagraphNode: return try renderParagraph(node: node)
        case let node as CodeBlockNode: return renderCodeBlock(node: node)
        case let node as OrderedListNode: return try renderOrderedList(node: node)
        case let node as UnorderedListNode: return try renderUnorderedList(node: node)
        case let node as BlockquoteNode: return try renderBlockquote(node: node)
        default: fatalError("Unsupported Node")
        }
    }
    
    func renderText(node: TextNode) -> String {
        return node.value
    }
    
    func renderHeaderOne(node: HeaderOneNode)throws -> String {
        let text = try node.content.map({ element in
            return try renderText(element as! ParagraphNode, withParagraph: false)
        }).joined()
        return "<h1>\(text)</h1>"
    }
    
    func renderHeaderTwo(node: HeaderTwoNode)throws -> String {
        let text = try node.content.map({ element in
            return try renderText(element as! ParagraphNode, withParagraph: false)
        }).joined()
        return "<h2>\(text)</h2>"
    }
    
    func renderHeaderThree(node: HeaderThreeNode)throws -> String {
        let text = try node.content.map({ element in
            return try renderText(element as! ParagraphNode, withParagraph: false)
        }).joined()
        return "<h3>\(text)</h3>"
    }
    
    func renderHeaderFour(node: HeaderFourNode)throws -> String {
        let text = try node.content.map({ element in
            return try renderText(element as! ParagraphNode, withParagraph: false)
        }).joined()
        return "<h4>\(text)</h4>"
    }
    
    func renderHeaderFive(node: HeaderFiveNode)throws -> String {
        let text = try node.content.map({ element in
            return try renderText(element as! ParagraphNode, withParagraph: false)
        }).joined()
        return "<h5>\(text)</h5>"
    }
    
    func renderHeaderSix(node: HeaderSixNode)throws -> String {
        let text = try node.content.map({ element in
            return try renderText(element as! ParagraphNode, withParagraph: false)
        }).joined()
        return "<h6>\(text)</h6>"
    }
    
    func renderBold(node: BoldNode)throws -> String {
        let text = try node.content.map({ element in
            return try renderText(element as! ParagraphNode, withParagraph: false)
        }).joined()
        return "<strong>\(text)</strong>"
    }
    
    func renderItalic(node: ItalicNode)throws -> String {
        let text = try node.content.map({ element in
            return try renderText(element as! ParagraphNode, withParagraph: false)
        }).joined()
        return "<em>\(text)</em>"
    }
    
    func renderLink(node: LinkNode)throws -> String {
        let text = try node.text.map({ element in
            return try renderText(element as! ParagraphNode, withParagraph: false)
        }).joined()
        return "<a href=\"\(node.url)\">\(text)</a>"
    }
    
    func renderImage(node: ImageNode) -> String {
        return "<img src=\"\(node.url)\" alt=\"\(node.text)\"/>"
    }
    
    func renderHorizontalRule(node: HorizontalRuleNode) -> String {
        return "<hr/>"
    }
    
    func renderBreak(node: BreakNode) -> String {
        return "<br/>"
    }
    
    func renderCode(node: CodeNode) -> String {
        return "<code>\(node.value)</code>"
    }
    
    func renderParagraph(node: ParagraphNode)throws -> String {
        return "<p>\(try node.content.map(renderNode).joined())</p>"
    }
    
    func renderCodeBlock(node: CodeBlockNode) -> String {
        return "<pre><code>\(node.code.joined(separator: "\n"))</code></pre>"
    }
    
    func renderOrderedList(node: OrderedListNode)throws -> String {
        let elements = try node.content.map({ element in
            return "<li>\(try renderText(element as! ParagraphNode, withParagraph: false))</li>"
        }).joined()
        return "<ol>\(elements)</ol>"
    }
    
    func renderUnorderedList(node: UnorderedListNode)throws -> String {
        let elements = try node.content.map({ element in
            return "<li>\(try renderText(element as! ParagraphNode, withParagraph: false))</li>"
        }).joined()
        return "<ul>\(elements)</ul>"
    }
    
    func renderBlockquote(node: BlockquoteNode)throws -> String {
        let elements = try node.content.map({
            return try renderText($0 as! ParagraphNode, withParagraph: true)
        }).joined()
        return "<blockquote>\(elements)</blockquote>"
    }
}
