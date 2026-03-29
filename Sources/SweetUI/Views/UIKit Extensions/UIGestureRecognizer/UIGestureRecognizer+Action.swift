import UIKit
import ObjectiveC


public extension UIGestureRecognizer {

    private class Handler: NSObject {
        var action: (() -> Void)?

        @objc
        func performAction() {
            action?()
        }
    }

    @discardableResult
    func addAction(_ action: @escaping (Self) -> Void) -> Any {
        let handler = Handler()
        handler.action = { [weak self] in
            guard let self = self as? Self else { return }
            action(self)
        }
        addTarget(handler, action: #selector(Handler.performAction))

        store(handler: handler)

        return handler
    }
}


// MARK: - Handler storage

private extension UIGestureRecognizer {
    
    static var handlersAssociatedObjectKey: UnsafeMutableRawPointer = malloc(8)!

    private func store(handler: Handler) {
        let handlers: NSMutableSet
        if let existing = objc_getAssociatedObject(self, &Self.handlersAssociatedObjectKey) as? NSMutableSet {
            handlers = existing
        } else {
            handlers = NSMutableSet()
            objc_setAssociatedObject(self, &Self.handlersAssociatedObjectKey, handler, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }

        handlers.add(handler)
    }
}
