import Foundation
import Combine


// MARK: - Assign

/// Take a keyPath and return a AnyCancellable
private extension SomeObject {

    func assign<V>(
        to keyPath: ReferenceWritableKeyPath<Self, V>,
        from publisher: some Publisher<V, Never>
    ) -> AnyCancellable {
        publisher.sink { [weak self] value in
            self?[keyPath: keyPath] = value
        }
    }

    func assign<V>(
        to keyPath: ReferenceWritableKeyPath<Self, V>,
        from publisherBuilder: () -> some Publisher<V, Never>
    ) -> AnyCancellable {
        let publisher = publisherBuilder()
        return publisher.sink { [weak self] value in
            self?[keyPath: keyPath] = value
        }
    }


    // MARK: Optional variants

    func assign<V>(
        to keyPath: ReferenceWritableKeyPath<Self, V?>,
        from publisher: some Publisher<V, Never>
    ) -> AnyCancellable {
        publisher.sink { [weak self] value in
            self?[keyPath: keyPath] = value
        }
    }

    func assign<V>(
        to keyPath: ReferenceWritableKeyPath<Self, V?>,
        from publisherBuilder: () -> some Publisher<V, Never>
    ) -> AnyCancellable {
        let publisher = publisherBuilder()
        return publisher.sink { [weak self] value in
            self?[keyPath: keyPath] = value
        }
    }
}


// MARK: - Sink

/// Take a closure and return a AnyCancellable
public extension SomeObject {

    func sink<V>(receiveValue publisher: some Publisher<V, Never>, perform action: @escaping (Self, V) -> Void) -> AnyCancellable {
        publisher.sink { [weak self] value in
            guard let self = self else {
                return
            }
            action(self, value)
        }
    }
}
