import UIKit


public extension UIViewController {

    convenience init(view builder: (Self) -> UIView) {
        self.init(nibName: nil, bundle: nil)
        self.view = builder(self)
        if self.view.backgroundColor == nil {
            self.view.backgroundColor = .systemBackground
        }
    }
}
