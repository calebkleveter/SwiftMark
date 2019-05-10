# Overview

```
[Byte]
	|
function {Lexer}
	| 
[Token]
	| 
function {Parser} 
	|
[ASLToken]
	|
function {Renderer}
	|
[Byte]
```

## Lexer

Takes in an array of arbitrary bytes and converts it to an array of tokens that represents the bytes.

So for this input:

```markdown
# Header

_Hello there!_ This is **Caleb**
```

You would get:

```swift
[
	Token.header1, 
	Token.raw([72, 101, 97, 100, 101, 114]), 
	Token.newLine,
	Token.newLine, 
	Token.underscore, 
	Token.raw([72, 101, 108, 108, 111, 32, 116, 104, 101, 114, 101, 33]),
	Token.underscore,
	Token.raw([84, 104, 105, 115, 32, 105, 115]),
	Token.asterisk,
	Token.asterisk,
	Token.raw([67, 97, 108, 101, 98]),
	Token.asterisk,
	Token.asterisk
]
```

## Parser

The parser takes in a list of lexer tokens and converts it to an abstract syntax list (ASL). We use an ASL instead of an AST (abstract syntax tree) because a tree causes recursion, which is often undesirable and causes a loss in performance.

For the lexer token list in the last section, you would get this output:

```swift
[
	Token.header1Open,
	Token.raw([72, 101, 97, 100, 101, 114]),
	Token.header1Close,
	Token.paragraphOpen,
	Token.emphasisOpen,
	Token.raw([72, 101, 108, 108, 111, 32, 116, 104, 101, 114, 101, 33]),
	Token.emphasisClose,
	Token.raw([84, 104, 105, 115, 32, 105, 115]),
	Token.strongOpen,
	Token.raw([67, 97, 108, 101, 98]),
	Token.strongClose,
	Token.paragraphClose
]
```

## Renderer

The renderer takes in an ASL and converts it to the HTML representation of the markdown as a byte list.

For the parser output in the last section, you would get the following output:

```
[60, 104, 49, 62, 72, 101, 97, 100, 101, 114, 60, 47, 104, 49, 62, 60, 112, 62, 60, 101, 109, 62, 72, 101, 108, 108, 111, 32, 116, 104, 101, 114, 101, 33, 60, 47, 101, 109, 62, 32, 84, 104, 105, 115, 32, 105, 115, 32, 60, 115, 116, 114, 111, 110, 103, 62, 67, 97, 108, 101, 98, 60, 47, 115, 116, 114, 111, 110, 103, 62, 60, 47, 112, 62]
```

Or if it was converted to text:

```html
<h1>Header</h1><p><em>Hello there!</em> This is <strong>Caleb</strong></p>
```

# Handing Byte Input

Incoming bytes should be able to be passed in as a single block, or streamed. This can be done by having a byte buffer that is appended to when a list of bytes is passed into the consumer. Ideally we wouldn't have to store bytes, but more bytes could come later that change how the HTML is rendered. 


```
# Header

_Hello there!_ This is **Caleb**
```

->

```
[
    .hash, .space, .raw("Header"), .newline("\n"), .newline("\n") .underscore, .raw("Hello"), .space, .raw("there"),
    .exclaimation, .underscore, .space, .raw("This"), .space, .raw("is"), .space, .asterik, .asterik, .raw("Caleb")
    .asterik, .asterik
]
```

->

```
[
    .headerOne(.start), .raw("Header"), .headerOne(.end), .paragraph(.start), .italics(.start), .raw("Hello there!"),
    .italics(.end), .raw(" This is "), .bold(.start), .raw("Caleb"), .bold(.end)
]
```

-> 

```
<h1>Header</h1><p><em>Hello there!</em> This is <strong>Caleb</strong></p>
```
