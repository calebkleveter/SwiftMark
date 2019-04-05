public func `while`<T>(_ expression: @autoclosure () -> Bool, _ closure: ()throws -> T)rethrows -> [T] {
    var result: ContiguousArray<T> = []
    result.reserveCapacity(16)
    
    while expression() {
        try result.append(closure())
    }
    
    return Array(result)
}

public func `while`<I, O>(_ expression: @autoclosure () -> I?, _ closure: (I)throws -> O)rethrows -> [O] {
    var result: ContiguousArray<O> = []
    result.reserveCapacity(16)
    
    while let input = expression() {
        try result.append(closure(input))
    }
    
    return Array(result)
}
