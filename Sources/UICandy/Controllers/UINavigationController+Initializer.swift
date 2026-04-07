import UIKit


public extension UINavigationController {

    convenience init(@ArrayBuilder<UIViewController> controllers stackBuilder: () -> [UIViewController]) {
        let stack = stackBuilder()
        self.init()
        self.setViewControllers(stack, animated: false)
    }
}
