# SwiftMark

[![Build Status](https://travis-ci.org/calebkleveter/SwiftMark.svg?branch=master)](https://travis-ci.org/calebkleveter/SwiftMark)

SwiftMark is a Markdown to HTML renderer built in Swift.

\#pureswift

## Usage

SwiftMark is a SwiftPM package (though versions 1.0.0 to 1.3.0 also work as a CocoaPod). Add this line to your dependencies array in your `Package.swift`:

```swift
Package(url: "https://github.com/calebkleveter/SwiftMark.git", majorVersion: 1)
```

Using SwiftMark is very simple. Just create a renderer, call `render`, and pass in the Markdown text.

```swift
do {
   let renderer = MarkdownRenderer()
   let html = try renderer.render(markdownText)
} catch let rror {
    print(error)
}
```

The result of the `.render()` method is the HTML form of the Markdown text passed in.

## License

The whole SwiftMark package is under the MIT license agreement.

## Attribution

Thanks to @matthewcheok and his tutorial on [Writing a Lexer in Swift](http://blog.matthewcheok.com/writing-a-lexer-in-swift/).
