import Parser

public protocol TokenRenderer {
    var supportedTokens: [String] { get }

    func render(token: Parser.Token) -> Renderer.Result?
}
