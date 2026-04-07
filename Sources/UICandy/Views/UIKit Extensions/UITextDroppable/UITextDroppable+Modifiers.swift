import UIKit


public extension UITextDroppable {

    func textDropDelegate(_ value: UITextDropDelegate?) -> Self {
        textDropDelegate = value
        return self
    }
}

