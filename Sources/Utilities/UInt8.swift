extension UInt8: ExpressibleByUnicodeScalarLiteral {
    public typealias UnicodeScalarLiteralType = Unicode.Scalar
    
    public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
        self = UInt8(ascii: value)
    }
}
