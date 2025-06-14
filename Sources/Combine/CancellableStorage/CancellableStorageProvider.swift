import Foundation
import Combine


@MainActor
public protocol CancellableStorageProvider {

    var cancellableStorage: CancellableStorage { get }
}



// MARK: - CancellableStorageProvider convenience

public extension CancellableStorageProvider {

    @discardableResult
    func storeCancellables<T>(with key: CancellableStorageKey = .unique(), actions: () -> T) -> T {
        cancellableStorage.storeCancellables(with: key, actions: actions)
    }

    @discardableResult
    func removeCancellable(forKey key: CancellableStorageKey) -> AnyCancellable? {
        cancellableStorage.removeCancellable(forKey: key)
    }
}


// MARK: - Cancellable convenience

public extension Cancellable {

    @MainActor
    func store(in provider: CancellableStorageProvider, withKey key: CancellableStorageKey = .unique()) {
        store(in: provider.cancellableStorage, withKey: key)
    }

    @MainActor
    func store(in storage: CancellableStorage, withKey key: CancellableStorageKey = .unique()) {
        let anyCancellable = self as? AnyCancellable ?? AnyCancellable(self)
        storage.storeCancellable(anyCancellable, withKey: key)
    }
}
