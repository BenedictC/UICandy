import UIKit
import Combine


public extension SomeView where Self: UIControl {

    func addAction(for event: UIControl.Event, with handler: @escaping (Self, UIControl.Event) -> Void) -> AnyCancellable {
        let target = ActionTarget { [weak self] event in
            guard let self = self else { return }
            handler(self, event)
        }
        self.addTarget(target, action: ActionTarget.handleEventSelector, for: event)

        return AnyCancellable { [weak self] in
            self?.removeTarget(target, action: ActionTarget.handleEventSelector, for: event)
        }
    }
}


// MARK: - Cancellable event handlers

private class ActionTarget: NSObject {

    typealias Handler = (UIControl.Event) -> Void

    static let handleEventSelector = #selector(ActionTarget.handleEvent(sender:event:))
    let handler: Handler


    init(handler: @escaping Handler) {
        self.handler = handler
    }

    @objc func handleEvent(sender: Any?, event: UIControl.Event) {
        handler(event)
    }
}

public extension SomeView where Self: UIControl {

    func disabled(_ publisher: some Publisher<Bool, Never>) -> Self {
        return enabled(publisher.inverted)
    }
}
