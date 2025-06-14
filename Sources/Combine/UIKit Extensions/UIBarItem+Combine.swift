import UIKit
import Combine


// MARK: Properties

public extension UIBarItem {

    func enabled(_ publisher: some Publisher<Bool, Never>) -> Self {
        // HACK ALERT! This causes a runtime crash due to a compiler bug related to the keyPath:
        // assign(to: \.isHidden, from: publisher, cancellableStorageProvider: cancellableStorageProvider)
        // So we have to do it the long way:
        publisher.sink { [weak self] value in
            self?.isEnabled = value
        }
        .store(in: CancellableStorage.current)
        return self
    }

    func title(_ publisher: some Publisher<String?, Never>) -> Self {
        // HACK ALERT! This causes a runtime crash due to a compiler bug related to the keyPath:
        // assign(to: \.isHidden, from: publisher, cancellableStorageProvider: cancellableStorageProvider)
        // So we have to do it the long way:
        publisher.sink { [weak self] value in
            self?.title = value
        }
        .store(in: CancellableStorage.current)
        return self
    }

    func image(_ publisher: some Publisher<UIImage?, Never>) -> Self {
        // HACK ALERT! This causes a runtime crash due to a compiler bug related to the keyPath:
        // assign(to: \.isHidden, from: publisher, cancellableStorageProvider: cancellableStorageProvider)
        // So we have to do it the long way:
        publisher.sink { [weak self] value in
            self?.image = value
        }
        .store(in: CancellableStorage.current)
        return self
    }
}
