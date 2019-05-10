import Parser

public protocol TokenRenderer {
    var renderType: String { get }

    func render(token: Parser.Token) -> [UInt8]?
}
