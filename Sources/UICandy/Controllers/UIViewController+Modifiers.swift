import UIKit


public extension UIViewController {

    func configure(using configuration: (Self) -> Void) -> Self {
        configuration(self)
        return self
    }
}
