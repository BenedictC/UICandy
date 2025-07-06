import UIKit


public extension UITextPasteConfigurationSupporting {

    func pasteDelegate(_ value: UITextPasteDelegate?) -> Self {
        pasteDelegate = value
        return self
    }
}
