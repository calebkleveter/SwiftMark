# SwiftMark

[![Build Status](https://travis-ci.org/calebkleveter/SwiftMark.svg?branch=master)](https://travis-ci.org/calebkleveter/SwiftMark)

SwiftMark is a Markdown renderer built in swift.

## Usage

SwiftMark is a SwiftPM package, but if you want to add it manually to a project, you can just add the files.

Using SwiftMark is very simple. Just create a renderer, call `render`, and pass in the Markdown text.

```swift
let renderer = MarkdownRenderer()
let html = renderer.render(markdownText)
```
If you only want the inline styles, you can use the `text(from: string)` method:

```swift
let html = renderer.text(from: string)
```

## License

The whole SwiftMark package is under the MIT license agreement.

## Attribution

Thanks to @matthewcheok and his tutorial on [Writing a Lexer in Swift](http://blog.matthewcheok.com/writing-a-lexer-in-swift/).

## TODO:

Update Podspec.
