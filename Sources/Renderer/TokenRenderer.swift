import Parser

public protocol TokenRenderer {
    var supportedTokens: [String] { get }

    func render(node: AST.Node, metadata: [String: MetadataElement]) -> Renderer.Result?
}
