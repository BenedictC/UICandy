import UIKit


public extension UISearchTextField {

    func delegate(_ value: UISearchTextFieldDelegate?) -> Self {
        delegate = delegate
        return self
    }

    func tokens(_ value: [UISearchToken]) -> Self {
        tokens = value
        return self
    }

    func tokenBackgroundColor(_ value: UIColor?) -> Self {
        tokenBackgroundColor = value
        return self
    }

    func allowsDeletingTokens(_ value: Bool) -> Self {
        allowsDeletingTokens = value
        return self
    }

    func allowsCopyingTokens(_ value: Bool) -> Self {
        allowsCopyingTokens = value
        return self
    }
}
