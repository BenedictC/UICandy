import Combine


// MARK: -

public protocol _Optionable {
    associatedtype Wrapped
}


extension Optional: _Optionable { }


extension _Optionable {

    internal var asOptional: Optional<Wrapped> {
        self as! Optional<Wrapped>
    }
}


// MARK: - Nil checks

public extension Publisher where Output: _Optionable {

    var isNil: some Publisher<Bool, Failure> {
        map { $0.asOptional == nil }
    }

    var isNotNil: some Publisher<Bool, Failure> {
        map { $0.asOptional != nil }
    }
}
