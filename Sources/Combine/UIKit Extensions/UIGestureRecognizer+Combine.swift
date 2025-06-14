import UIKit
import Combine


public extension UIGestureRecognizer {

    private class Handler: NSObject {
        var action: (() -> Void)?

        @objc
        func performAction() {
            action?()
        }
    }

    func addAction(_ action: @escaping (Self) -> Void) -> AnyCancellable {
        let handler = Handler()
        handler.action = { [weak self] in
            guard let self = self as? Self else { return }
            action(self)
        }
        addTarget(handler, action: #selector(Handler.performAction))

        let cancellable = AnyCancellable { [weak self] in
            self?.removeTarget(handler, action: #selector(Handler.performAction))
        }
        return cancellable
    }
}
