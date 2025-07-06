import UIKit


public extension UIActivityIndicatorView {

    var isActive: Bool {
        get { isAnimating }
        set {
            if newValue {
                startAnimating()
            } else {
                stopAnimating()
            }
        }
    }

    func style(_ value: Style) -> Self {
        self.style = value
        return self
    }

    func hidesWhenStopped(_ value: Bool) -> Self {
        self.hidesWhenStopped = value
        return self
    }

    func color(_ value: UIColor?) -> Self {
        self.color = value
        return self
    }

    func animate(_ value: Bool) -> Self {
        if value {
            startAnimating()
        } else {
            stopAnimating()
        }
        return self
    }
}
