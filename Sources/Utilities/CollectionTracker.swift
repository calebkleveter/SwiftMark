public struct CollectionTracker<Base> where Base: Collection {
    private var readIndex: Base.Index
    public private(set) var base: Base
    
    public var readable: Int {
        return self.base.distance(from: self.readIndex, to: self.base.endIndex)
    }
    
    public init(_ base: Base) {
        self.readIndex = base.startIndex
        self.base = base
    }
    
    private func readable(offsetBy offset: Int) -> Base.Index {
        return self.base.index(self.readIndex, offsetBy: offset, limitedBy: self.base.endIndex) ?? self.base.endIndex
    }
    
    public func peek(next distance: Int) -> Base.SubSequence {
        return self.base[self.readIndex...self.readable(offsetBy: distance)]
    }
    
    public func peek() -> Base.Element? {
        guard self.base.endIndex > self.readIndex else { return nil }
        return self.base[self.readIndex]
    }
    
    public mutating func read(next distance: Int) -> Base.SubSequence {
        defer { self.readIndex = self.readable(offsetBy: distance) }
        return self.base[self.readIndex...self.readable(offsetBy: distance)]
    }
    
    public mutating func read() -> Base.Element? {
        defer { self.readIndex = self.readable(offsetBy: 1) }
        guard self.base.endIndex > self.readIndex else { return nil }
        return self.base[self.readIndex]
    }
}
