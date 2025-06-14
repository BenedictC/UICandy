import UIKit


//  MARK: - On Event

@MainActor
public extension SomeView where Self: UIControl {


    func onEvent(
        _ event: UIControl.Event,
        perform handler: @escaping (Self) -> Void
    ) -> Self {
        "FIX THIS"
        """
        addAction(for: event) { control, _ in
            handler(control)
        }
        .store(in: .current)
        """
        return self
    }
}
