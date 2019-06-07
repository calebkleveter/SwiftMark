public typealias ASCIISet = Set<UInt8>

extension ASCIISet {
    public static let control: ASCIISet = [
        0x0, 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xA, 0xB, 0xC, 0xD, 0xE, 0xF, 0x10, 0x11,
        0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F, 0x7F
    ]
    public static let whitespace: ASCIISet = [9, 10, 11, 12, 13, 32]
}

extension Sequence where Element == UInt8 {
    public func has( _ set: ASCIISet) -> Bool {
        for byte in self {
            if set.contains(byte) {
                return true
            }
        }
        return false
    }
}

extension String {
    public func has(_ set: ASCIISet) -> Bool {
        for byte in self.utf8 {
            if set.contains(byte) {
                return true
            }
        }
        return false
    }
}
