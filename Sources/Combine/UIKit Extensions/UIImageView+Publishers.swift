import UIKit
import Combine


// MARK: - Modifiers

public extension UIImageView {
    
    convenience init(image publisher: some Publisher<UIImage, Never>) {
        self.init()
        // HACK ALERT! This causes a runtime crash due to a compiler bug related to the keyPath:
        // _ = self.assign(to: \.image, from: publisher, cancellableStorageProvider: cancellableStorageProvider)
        // So we have to do it the long way:
        publisher.sink { [weak self] value in
            self?.image = value
        }
        .store(in: CancellableStorage.current)
    }
    
    convenience init(image publisher: some Publisher<UIImage?, Never>) {
        self.init()
        // HACK ALERT! This causes a runtime crash due to a compiler bug related to the keyPath:
        // _ = self.assign(to: \.image, from: publisher, cancellableStorageProvider: cancellableStorageProvider)
        // So we have to do it the long way:
        publisher.sink { [weak self] value in
            self?.image = value
        }
        .store(in: CancellableStorage.current)
    }
    
    func image(_ publisher: some Publisher<UIImage, Never>) -> Self {
        // HACK ALERT! This causes a runtime crash due to a compiler bug related to the keyPath:
        // assign(to: \.image, from: publisher, cancellableStorageProvider: cancellableStorageProvider)
        // So we have to do it the long way:
        publisher.sink { [weak self] value in
            self?.image = value
        }
        .store(in: CancellableStorage.current)
        return self
    }
    
    func image(_ publisher: some Publisher<UIImage?, Never>) -> Self {
        // HACK ALERT! This causes a runtime crash due to a compiler bug related to the keyPath:
        // assign(to: \.image, from: publisher, cancellableStorageProvider: cancellableStorageProvider)
        // So we have to do it the long way:
        publisher.sink { [weak self] value in
            self?.image = value
        }
        .store(in: CancellableStorage.current)
        return self
    }
}
