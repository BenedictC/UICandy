import Foundation
import Combine


// MARK: - Bind

/// Take a keyPath and return Self
@MainActor
public extension SomeObject {
    
    @discardableResult
    func assign<Output>(
        to destinationKeyPath: ReferenceWritableKeyPath<Self, Output>,
        from publisher: some Publisher<Output, Never>
    ) -> Self {
        publisher.sink { [weak self] value in
            self?[keyPath: destinationKeyPath] = value
        }
        .store(in: .current)
        return self
    }
    
    
    // MARK: Promote non-optional publisher to optional
    
    @discardableResult
    func assign<Output>(
        to destinationKeyPath: ReferenceWritableKeyPath<Self, Output?>,
        from publisher: some Publisher<Output, Never>
    ) -> Self {
        publisher.sink { [weak self] value in
            self?[keyPath: destinationKeyPath] = value
        }
        .store(in: .current)
        return self
    }
}


// MARK: - OnChange

/// Take a closure and return Self
@MainActor
public extension SomeObject {
    
    @discardableResult
    func onChange<Output>(
        of publisher: some Publisher<Output, Never>,
        perform action: @escaping (Self, Output) -> Void
    ) -> Self {
        // We don't need to store action because it's captured in a block is stored
        publisher.sink { [weak self] newValue in
            guard let self else { return }
            action(self, newValue)
        }
        .store(in: .current)
        return self
    }
}
