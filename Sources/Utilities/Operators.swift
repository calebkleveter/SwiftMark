public typealias Operator<I, O> = (I, I) -> O
public typealias HalfOperation<I, O> = (I) -> O

internal func store<I, O>(_ value: I, to operation: @escaping Operator<I, O>) -> HalfOperation<I, O> {
    return { i in operation(i, value) }
}


public func || <E>(lhs: E, rhs: E) -> HalfOperation<HalfOperation<E, Bool>, Bool> where E: Equatable {
    return { operation in
        return operation(lhs) || operation(rhs)
    }
}

public func && <E>(lhs: E, rhs: E) -> HalfOperation<HalfOperation<E, Bool>, Bool> where E: Equatable {
    return { operation in
        return operation(lhs) && operation(rhs)
    }
}


public func == <E>(lhs: E, operation: HalfOperation<HalfOperation<E, Bool>, Bool>) -> Bool where E: Equatable {
    return operation(store(lhs, to: ==))
}

public func != <E>(lhs: E, operation: HalfOperation<HalfOperation<E, Bool>, Bool>) -> Bool where E: Equatable {
    return operation(store(lhs, to: !=))
}

public func > <C>(lhs: C, operation: HalfOperation<HalfOperation<C, Bool>, Bool>) -> Bool where C: Comparable {
    return operation(store(lhs, to: >))
}

public func < <C>(lhs: C, operation: HalfOperation<HalfOperation<C, Bool>, Bool>) -> Bool where C: Comparable {
    return operation(store(lhs, to: <))
}

public func >= <C>(lhs: C, operation: HalfOperation<HalfOperation<C, Bool>, Bool>) -> Bool where C: Comparable {
    return operation(store(lhs, to: >=))
}

public func <= <C>(lhs: C, operation: HalfOperation<HalfOperation<C, Bool>, Bool>) -> Bool where C: Comparable {
    return operation(store(lhs, to: <=))
}
