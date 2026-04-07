

// MARK: - Variable Store

public func store<T>(_ value: T, in ref: inout T?) -> T {
    ref = value
    return value
}


public extension SomeView {

    // `store<T>(in property: inout T) -> Self where Self: T` would be preferable but that isn't valid.
    func store(in ref: inout Self) -> Self {
        ref = self
        return self
    }

    func store(in ref: inout Self?) -> Self {
        ref = self
        return self
    }
}


// MARK: - StorageBox Storage

public final class StorageBox<T> {

    public var boxed: T { value }
    public var value: T {
        guard let wrappedValue else {
            preconditionFailure("Attempted to access a boxed value before the value has been set.")
        }
        return wrappedValue
    }

    internal var wrappedValue: T? {
        willSet {
            precondition(wrappedValue == nil, "Attempted to set the value of a box twice.")
        }
    }

    internal init() { }
}


public extension SomeObject {

    func store(in box: StorageBox<Self>) -> Self {
        box.wrappedValue = self
        return self
    }
}


// MARK: - withStorage

public func withStorage<T, V0>(
    _ block: (StorageBox<V0>) -> T
) -> T {
    return block(StorageBox())
}

public func withStorage<T, V0, V1>(
    _ block: (StorageBox<V0>, StorageBox<V1>) -> T
) -> T {
    return block(StorageBox(), StorageBox())
}

public func withStorage<T, V0, V1, V2>(
    _ block: (StorageBox<V0>, StorageBox<V1>, StorageBox<V2>) -> T
) -> T {
    return block(StorageBox(), StorageBox(), StorageBox())
}

public func withStorage<T, V0, V1, V2, V3>(
    _ block: (StorageBox<V0>, StorageBox<V1>, StorageBox<V2>, StorageBox<V3>) -> T
) -> T {
    return block(StorageBox(), StorageBox(), StorageBox(), StorageBox())
}

public func withStorage<T, V0, V1, V2, V3, V4>(
    _ block: (StorageBox<V0>, StorageBox<V1>, StorageBox<V2>, StorageBox<V3>, StorageBox<V4>) -> T
) -> T {

    return block(StorageBox(), StorageBox(), StorageBox(), StorageBox(), StorageBox())
}

public func withStorage<T, V0, V1, V2, V3, V4, V5>(
    _ block: (StorageBox<V0>, StorageBox<V1>, StorageBox<V2>, StorageBox<V3>, StorageBox<V4>, StorageBox<V5>) -> T
) -> T {
    return block(StorageBox(), StorageBox(), StorageBox(), StorageBox(), StorageBox(), StorageBox())
}

public func withStorage<T, V0, V1, V2, V3, V4, V5, V6>(
    _ block: (StorageBox<V0>, StorageBox<V1>, StorageBox<V2>, StorageBox<V3>, StorageBox<V4>, StorageBox<V5>, StorageBox<V6>) -> T
) -> T {
    return block(StorageBox(), StorageBox(), StorageBox(), StorageBox(), StorageBox(), StorageBox(), StorageBox())
}

public func withStorage<T, V0, V1, V2, V3, V4, V5, V6, V7>(
    _ block: (StorageBox<V0>, StorageBox<V1>, StorageBox<V2>, StorageBox<V3>, StorageBox<V4>, StorageBox<V5>, StorageBox<V6>, StorageBox<V7>) -> T
) -> T {
    return block(StorageBox(), StorageBox(), StorageBox(), StorageBox(), StorageBox(), StorageBox(), StorageBox(), StorageBox())
}

public func withStorage<T, V0, V1, V2, V3, V4, V5, V6, V7, V8>(
    _ block: (StorageBox<V0>, StorageBox<V1>, StorageBox<V2>, StorageBox<V3>, StorageBox<V4>, StorageBox<V5>, StorageBox<V6>, StorageBox<V7>, StorageBox<V8>) -> T
) -> T {
    return block(StorageBox(), StorageBox(), StorageBox(), StorageBox(), StorageBox(), StorageBox(), StorageBox(), StorageBox(), StorageBox())
}

public func withStorage<T, V0, V1, V2, V3, V4, V5, V6, V7, V8, V9>(
    _ block: (StorageBox<V0>, StorageBox<V1>, StorageBox<V2>, StorageBox<V3>, StorageBox<V4>, StorageBox<V5>, StorageBox<V6>, StorageBox<V7>, StorageBox<V8>, StorageBox<V9>) -> T
) -> T {
    return block(StorageBox(), StorageBox(), StorageBox(), StorageBox(), StorageBox(), StorageBox(), StorageBox(), StorageBox(), StorageBox(), StorageBox())
}

