import UIKit
import Combine


public extension UIActivityIndicatorView {
    
    convenience init(style: UIActivityIndicatorView.Style,isActive publisher: some Publisher<Bool, Never>) {
        self.init(style: style)
        // HACK ALERT! This causes a runtime crash due to a compiler bug related to the keyPath:
        //_ = self.active(publisher, cancellableStorageProvider: cancellableStorageProvider)
        // So we have to do it the long way:
        publisher.sink { [weak self] value in
            self?.isActive = value
        }
        .store(in: CancellableStorage.current)
    }
    
    func active(_ publisher: some Publisher<Bool, Never>) -> Self {
        // HACK ALERT! This causes a runtime crash due to a compiler bug related to the keyPath:
        // assign(to: \.isActive, from: publisher, cancellableStorageProvider: cancellableStorageProvider)
        // So we have to do it the long way:
        publisher.sink { [weak self] value in
            self?.isActive = value
        }
        .store(in: CancellableStorage.current)
        return self
    }
}
