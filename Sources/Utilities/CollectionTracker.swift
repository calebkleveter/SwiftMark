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
        return self.base[self.readIndex..<self.readable(offsetBy: distance)]
    }
    
    public func peek() -> Base.Element? {
        guard self.base.endIndex > self.readIndex else { return nil }
        return self.base[self.readIndex]
    }
    
    public mutating func read(next distance: Int) -> Base.SubSequence {
        defer { self.readIndex = self.readable(offsetBy: distance) }
        return self.base[self.readIndex..<self.readable(offsetBy: distance)]
    }
    
    public mutating func read() -> Base.Element? {
        defer { self.readIndex = self.readable(offsetBy: 1) }
        guard self.base.endIndex > self.readIndex else { return nil }
        return self.base[self.readIndex]
    }
    
    public mutating func pop(next distance: Int) {
        self.readIndex = self.readable(offsetBy: distance)
    }
    
    public mutating func pop() {
        self.readIndex = self.readable(offsetBy: 1) 
    }
}

extension CollectionTracker: Equatable where Base: Equatable { }

extension CollectionTracker where Base.Element: Equatable {
    public mutating func read(to last: Base.Element, max: Int? = nil) -> Base.SubSequence {
        let endIndex = self.readable(offsetBy: max ?? self.readable)
        let slice = self.base[self.readable(offsetBy: 0)..<endIndex]
        let result = slice.prefix { element in element != last }
        
        self.readIndex = self.readable(offsetBy: result.count)
        return result
    }
    
    public mutating func read(while predicate: (Base.Element)throws -> Bool, max: Int? = nil)rethrows -> Base.SubSequence {
        let endIndex = self.readable(offsetBy: max ?? self.readable)
        let slice = self.base[self.readable(offsetBy: 0)..<endIndex]
        let result = try slice.prefix(while: predicate)
        
        self.readIndex = self.readable(offsetBy: result.count)
        return result
    }
}
