// The MIT License (MIT)
//
// Copyright (c) 2018 Caleb Kleveter
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Lexer
import Parser
import Renderer
import Utilities

public struct Config {
    public let renderers: (all: [Syntax], `default`: Syntax)

    public init(renderers: [Syntax], `default`: Syntax) {
        self.renderers = (renderers, `default`)
    }
}


public final class SwiftMark {
    public let config: Config

    private let lexer: Lexer
    private let parser: Parser
    private let renderer: Renderer

    public init(config: Config) {
        self.config = config

        self.lexer = Lexer(generators: .default)
        self.parser = Parser(generators: .init(handlers: config.renderers.all, default: config.renderers.default))
        self.renderer = Renderer(renderers: .init(handlers: config.renderers.all, default: config.renderers.default))
    }

    public func render(markdown: [UInt8])throws -> [UInt8] {
        let cleaned = self.lexer.clean(data: markdown)
        let lexed = try self.lexer.lex(string: cleaned)
        let parsed = try self.parser.parse(tokens: lexed)
        let rendered = try self.renderer.render(tokens: parsed)

        return rendered
    }
}
