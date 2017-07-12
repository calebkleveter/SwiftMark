# SwiftMark

[![Build Status](https://travis-ci.org/calebkleveter/SwiftMark.svg?branch=master)](https://travis-ci.org/calebkleveter/SwiftMark)

SwiftMark is a Markdown renderer built in swift.

## Usage

SwiftMark is a SwiftPM package (though versions 1.0.0 to 1.3.0 also work as a CocoaPod). Add this line to your dependencies array in your `Package.swift`:

```swift
Package(url: "https://github.com/calebkleveter/SwiftMark.git", majorVersion: 1)
```

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
