import UIKit


//  MARK: - On Event

public extension SomeView where Self: UIControl {

    func onEvent(_ event: UIControl.Event, send action: Selector, to target: Any? = nil) -> Self {
        self.addTarget(target, action: action, for: event)
        return self
    }

    @available(iOS 14.0, *)
    @discardableResult
    func onEvent(
        _ event: UIControl.Event,
        identifier: UIAction.Identifier? = nil,
        perform handler: @escaping (Self) -> Void
    ) -> Self {
        let action = UIAction(identifier: identifier, handler: { [weak self] _ in
            guard let self else { return }
            handler(self)
        })
        self.addAction(action, for: event)
        return self
    }
}
