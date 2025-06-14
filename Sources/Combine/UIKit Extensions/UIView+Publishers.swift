import UIKit
import Combine


// MARK: - Modifiers

public extension UIView {

    func hidden(_ publisher: some Publisher<Bool, Never>) -> Self {
        // HACK ALERT! This causes a runtime crash due to a compiler bug related to the keyPath:
        // assign(to: \.isHidden, from: publisher, cancellableStorageProvider: cancellableStorageProvider)
        // So we have to do it the long way:
        onChange(of: publisher, perform: { $0.isHidden = $1 })
    }

    func alpha(_ publisher: some Publisher<CGFloat, Never>) -> Self {
        // HACK ALERT! This causes a runtime crash due to a compiler bug related to the keyPath:
        // assign(to: \.alpha, from: publisher, cancellableStorageProvider: cancellableStorageProvider)
        // So we have to do it the long way:
        onChange(of: publisher, perform: { $0.alpha = $1 })
    }

    func backgroundColor(_ publisher: some Publisher<UIColor, Never>) -> Self {
        // HACK ALERT! This causes a runtime crash due to a compiler bug related to the keyPath:
        // assign(to: \.backgroundColor, from: publisher, cancellableStorageProvider: cancellableStorageProvider)
        // So we have to do it the long way:
        onChange(of: publisher, perform: { $0.backgroundColor = $1 })
    }

    func userInteractionEnabled(_ publisher: some Publisher<Bool, Never>) -> Self {
        // HACK ALERT! This causes a runtime crash due to a compiler bug related to the keyPath:
        // assign(to: \.isUserInteractionEnabled, from: publisher, cancellableStorageProvider: cancellableStorageProvider)
        // So we have to do it the long way:
        onChange(of: publisher, perform: { $0.isUserInteractionEnabled = $1 })
    }
}
