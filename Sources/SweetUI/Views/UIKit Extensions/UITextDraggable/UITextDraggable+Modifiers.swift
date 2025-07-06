import UIKit


public extension UITextDraggable {

    func textDragDelegate(_ value: UITextDragDelegate?) -> Self {
        textDragDelegate = value
        return self
    }

    func textDragOptions(_ value: UITextDragOptions) -> Self {
        textDragOptions = value
        return self
    }
}
