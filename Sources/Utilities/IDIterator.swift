public final class IDIterator {
    public static let instance: IDIterator = IDIterator(start: 0)
    
    internal var current: UInt8
    
    internal init(start: UInt8) {
        self.current = start
    }
    
    public func next() -> UInt8 {
        defer { self.current += 1 }
        return self.current
    }
}
