import Foundation
import Combine


// MARK: - CancellableStorage

public final class CancellableStorage {

    // MARK: Properties

    private let isFallback: Bool
    private var cancellablesByKey = [CancellableStorageKey: AnyCancellable]()

    private var unionCancellable: AnyCancellable {
        let children = cancellablesByKey.values
        return AnyCancellable {
            for child in children { child.cancel() }
        }
    }


    // MARK: Instance life cycle

    public init() {
        self.isFallback = false
    }
    
    private init(isFallback: Bool) {
        self.isFallback = isFallback
    }


    // MARK: Core storage

    public func storeCancellable(_ cancellable: AnyCancellable, withKey key: CancellableStorageKey = .unique()) {
        if isFallback {
            runtimeWarn("Attempt to store cancellable with key '\(key.identifier)' while outside of a CancellableStorage scope. Cancellable will be stored but cannot be released.")
            cancellablesByKey[.unique()] = cancellable
        } else {
            cancellablesByKey[key] = cancellable
        }
    }

    @discardableResult
    public func removeCancellable(forKey key: CancellableStorageKey) -> AnyCancellable? {
        cancellablesByKey.removeValue(forKey: key)
    }

    public func adoptCancellables(from other: CancellableStorage) {
        if other === self { return }
        for (key, value) in other.cancellablesByKey {
            self.cancellablesByKey[key] = value
        }
        other.cancellablesByKey = [:]
    }
}


// MARK: - Global stack management

public extension CancellableStorage {

    private static var storageStack: [CancellableStorage] = [CancellableStorage(isFallback: true)]

    @MainActor
    static var current: CancellableStorage {
        guard let top = storageStack.last else {
            preconditionFailure("providersStack should contain at least 1 element.")
        }
        return top
    }

    @discardableResult
    static func push(_ cancellableStorage: CancellableStorage) -> CancellableStorage {
        storageStack.append(cancellableStorage)
        return cancellableStorage
    }

    @discardableResult
    static func pop(expected: CancellableStorage? = nil) -> CancellableStorage {
        let actual = storageStack.removeLast()
        if let expected {
            assert(actual === expected)
        }
        return actual
    }
}


// MARK: - Collection that returns a Cancellable

public extension CancellableStorage {
    
    @discardableResult
    static func storeCancellables<T>(in cancellable: inout AnyCancellable?, action: () -> T) -> T {
        let storage = CancellableStorage()
        push(storage)
        let result = action()
        let last = Self.storageStack.removeLast()
        assert(last === storage)
        
        cancellable = storage.unionCancellable
        return result
    }
    
    static func storeCancellables(action: () -> Void) -> AnyCancellable {
        var cancellable: AnyCancellable?
        storeCancellables(in: &cancellable, action: action)
        guard let cancellable else {
            return AnyCancellable { } // Shouldn't happen!
        }
        return cancellable
    }
}


// MARK: - Collection that stores in storage

public extension CancellableStorage {
    
    @discardableResult
    func storeCancellables<T>(with key: CancellableStorageKey = .unique(), actions: () -> T) -> T {
        var cancellable: AnyCancellable?
        let result = Self.storeCancellables(in: &cancellable, action: actions)
        if let cancellable {
            storeCancellable(cancellable, withKey: key)
        } else {
            // Shouldn't happen!
        }
        return result
    }
}
