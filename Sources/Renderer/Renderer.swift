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
        return  ast.map(renderNode).joined()
    }
    
    private func renderText(_ node: ParagraphNode, withParagraph: Bool) -> String {
        let text =  node.content.map(renderNode).joined()
        if withParagraph {
            return "<p>\(text)</p>"
        } else {
            return "\(text)"
        }
    }
    
    public func renderNode(_ node: ElementNode) -> String {
        switch node {
        case let node as TextNode: return renderText(node: node)
        case let node as HeaderOneNode: return  renderHeaderOne(node: node)
        case let node as HeaderTwoNode: return  renderHeaderTwo(node: node)
        case let node as HeaderThreeNode: return  renderHeaderThree(node: node)
        case let node as HeaderFourNode: return  renderHeaderFour(node: node)
        case let node as HeaderFiveNode: return  renderHeaderFive(node: node)
        case let node as HeaderSixNode: return  renderHeaderSix(node: node)
        case let node as BoldNode: return  renderBold(node: node)
        case let node as ItalicNode: return  renderItalic(node: node)
        case let node as LinkNode: return  renderLink(node: node)
        case let node as ImageNode: return renderImage(node: node)
        case let node as HorizontalRuleNode: return renderHorizontalRule(node: node)
        case let node as BreakNode: return renderBreak(node: node)
        case let node as CodeNode: return renderCode(node: node)
        case let node as ParagraphNode: return  renderParagraph(node: node)
        case let node as CodeBlockNode: return renderCodeBlock(node: node)
        case let node as OrderedListNode: return  renderOrderedList(node: node)
        case let node as UnorderedListNode: return  renderUnorderedList(node: node)
        case let node as BlockquoteNode: return  renderBlockquote(node: node)
        default: fatalError("Unsupported Node")
        }
    }
    
    private func renderText(node: TextNode) -> String {
        return node.value
    }
    
    private func renderHeaderOne(node: HeaderOneNode) -> String {
        let text =  node.content.map({ element in
            return  renderText(element as! ParagraphNode, withParagraph: false)
        }).joined()
        return "<h1>\(text)</h1>"
    }
    
    private func renderHeaderTwo(node: HeaderTwoNode) -> String {
        let text =  node.content.map({ element in
            return  renderText(element as! ParagraphNode, withParagraph: false)
        }).joined()
        return "<h2>\(text)</h2>"
    }
    
    private func renderHeaderThree(node: HeaderThreeNode) -> String {
        let text =  node.content.map({ element in
            return  renderText(element as! ParagraphNode, withParagraph: false)
        }).joined()
        return "<h3>\(text)</h3>"
    }
    
    private func renderHeaderFour(node: HeaderFourNode) -> String {
        let text =  node.content.map({ element in
            return  renderText(element as! ParagraphNode, withParagraph: false)
        }).joined()
        return "<h4>\(text)</h4>"
    }
    
    private func renderHeaderFive(node: HeaderFiveNode) -> String {
        let text =  node.content.map({ element in
            return  renderText(element as! ParagraphNode, withParagraph: false)
        }).joined()
        return "<h5>\(text)</h5>"
    }
    
    private func renderHeaderSix(node: HeaderSixNode) -> String {
        let text =  node.content.map({ element in
            return  renderText(element as! ParagraphNode, withParagraph: false)
        }).joined()
        return "<h6>\(text)</h6>"
    }
    
    private func renderBold(node: BoldNode) -> String {
        let text =  node.content.map({ element in
            return  renderText(element as! ParagraphNode, withParagraph: false)
        }).joined()
        return "<strong>\(text)</strong>"
    }
    
    private func renderItalic(node: ItalicNode) -> String {
        let text =  node.content.map({ element in
            return  renderText(element as! ParagraphNode, withParagraph: false)
        }).joined()
        return "<em>\(text)</em>"
    }
    
    private func renderLink(node: LinkNode) -> String {
        let text =  node.text.map({ element in
            return  renderText(element as! ParagraphNode, withParagraph: false)
        }).joined()
        return "<a href=\"\(node.url)\">\(text)</a>"
    }
    
    private func renderImage(node: ImageNode) -> String {
        return "<img src=\"\(node.url)\" alt=\"\(node.text)\"/>"
    }
    
    private func renderHorizontalRule(node: HorizontalRuleNode) -> String {
        return "<hr/>"
    }
    
    private func renderBreak(node: BreakNode) -> String {
        return "<br/>"
    }
    
    private func renderCode(node: CodeNode) -> String {
        return "<code>\(node.value)</code>"
    }
    
    private func renderParagraph(node: ParagraphNode) -> String {
        return "<p>\( node.content.map(renderNode).joined())</p>"
    }
    
    private func renderCodeBlock(node: CodeBlockNode) -> String {
        return "<pre><code>\(node.code.joined(separator: "\n"))</code></pre>"
    }
    
    private func renderOrderedList(node: OrderedListNode) -> String {
        let elements =  node.content.map({ element in
            return "<li>\( renderText(element as! ParagraphNode, withParagraph: false))</li>"
        }).joined()
        return "<ol>\(elements)</ol>"
    }
    
    private func renderUnorderedList(node: UnorderedListNode) -> String {
        let elements =  node.content.map({ element in
            return "<li>\( renderText(element as! ParagraphNode, withParagraph: false))</li>"
        }).joined()
        return "<ul>\(elements)</ul>"
    }
    
    private func renderBlockquote(node: BlockquoteNode) -> String {
        let elements =  node.content.map({
            return  renderText($0 as! ParagraphNode, withParagraph: true)
        }).joined()
        return "<blockquote>\(elements)</blockquote>"
    }
}
