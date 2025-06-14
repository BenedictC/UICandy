import Combine


// MARK: - Static values

public extension Publisher where Output: Equatable {

    func isEqualTo(_ value: Output) -> some Publisher<Bool, Failure> {
        map { $0 == value }
    }

    func isNotEqualTo(_ value: Output) -> some Publisher<Bool, Failure> {
        map { $0 != value }
    }
}


public extension Publisher where Output: Comparable {

    func isLessThan(_ value: Output) -> some Publisher<Bool, Failure> {
        map { $0 < value }
    }

    func isGreaterThan(_ value: Output) -> some Publisher<Bool, Failure> {
        map { $0 > value }
    }

    func isLessThanOrEqualTo(_ value: Output) -> some Publisher<Bool, Failure> {
        map { $0 <= value }
    }

    func isGreaterThanOrEqualTo(_ value: Output) -> some Publisher<Bool, Failure> {
        map { $0 >= value }
    }
}


// MARK: - Publishers

public extension Publisher where Output: Equatable {

    func isEqualTo(_ other: some Publisher<Output, Failure>) -> some Publisher<Bool, Failure> {
        combineLatest(other)
            .map { $0.0 == $0.1 }
    }

    func isNotEqualTo(_ other: some Publisher<Output, Failure>) -> some Publisher<Bool, Failure> {
        combineLatest(other)
            .map { $0.0 != $0.1 }
    }
}


public extension Publisher where Output: Comparable {

    func isLessThan(_ other: some Publisher<Output, Failure>) -> some Publisher<Bool, Failure> {
        combineLatest(other)
            .map { $0.0 < $0.1 }
    }

    func isGreaterThan(_ other: some Publisher<Output, Failure>) -> some Publisher<Bool, Failure> {
        combineLatest(other)
            .map { $0.0 > $0.1 }
    }

    func isLessThanOrEqualTo(_ other: some Publisher<Output, Failure>) -> some Publisher<Bool, Failure> {
        combineLatest(other)
            .map { $0.0 <= $0.1 }
    }

    func isGreaterThanOrEqualTo(_ other: some Publisher<Output, Failure>) -> some Publisher<Bool, Failure> {
        combineLatest(other)
            .map { $0.0 >= $0.1 }
    }
}
