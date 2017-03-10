# SwiftDown

[![Build Status](https://travis-ci.org/calebkleveter/SwiftDown.svg?branch=master)](https://travis-ci.org/calebkleveter/SwiftDown)

SwiftDown is a Markdown renderer built in swift.

## Usage

SwiftDown is a SwiftPM package, but if you want to add it manually to a project, you can just add the files.

Using SwiftDown is very simple. Just create a renderer, call `render`, and pass in the Markdown text.

```swift
let renderer = MarkdownRenderer()
let html = renderer.render(markdownText)
```

## License

The whole SwiftDown package is under the MIT license agreement.

## Attribution

Thanks to @matthewcheok and his tutorial on [Writing a Lexer in Swift](http://blog.matthewcheok.com/writing-a-lexer-in-swift/).
