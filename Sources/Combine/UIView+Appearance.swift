import Foundation
import Combine
import UIKit


internal extension NSNotification.Name {
    static let viewDidAppear = Self("sweetUI.UIView.didAppear")
}


private struct UncheckedCompletionHandler: @unchecked Sendable {
    let handler: (Notification) -> Void
}


@MainActor
public extension SomeView {
    
    func onDidAppear(
        handler: @escaping (Self) -> Void
    ) -> Self {
        
        let completionHandler = UncheckedCompletionHandler { [weak self] notification in
            guard
                let sendingViewController = notification.object as? UIViewController,
                let self else { return }
            
            var next = self.next
            while let current = next {
                guard let containingVC = current as? UIViewController else {
                    next = current.next
                    continue
                }
                let isMatch = containingVC == sendingViewController
                guard isMatch else { return }
                handler(self)
                // No view controller found in the responder chain. Very strange.
                return
            }
        }
        
        let observer = NotificationCenter.default.addObserver(forName: .viewDidAppear, object: nil, queue: nil) {
            completionHandler.handler($0)
        }
        
        AnyCancellable { NotificationCenter.default.removeObserver(observer) }
            .store(in: .current)
        return self
    }
}
