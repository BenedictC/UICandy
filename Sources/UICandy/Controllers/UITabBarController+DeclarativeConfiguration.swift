import UIKit


public extension UITabBarController {

    convenience init(
        delegate: UITabBarControllerDelegate? = DefaultTabBarControllerDelegate.shared,
        @ArrayBuilder<UIViewController> childViewControllers builder: () -> [UIViewController])
    {
        self.init()
        self.delegate = delegate
        let childViewControllers = builder()
        self.setViewControllers(childViewControllers, animated: false)
    }
}


// MARK: - DefaultTabBarControllerDelegate

public final class DefaultTabBarControllerDelegate: NSObject, UITabBarControllerDelegate {

    public static let shared = DefaultTabBarControllerDelegate()

    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let isAlreadySelected = tabBarController.selectedViewController == viewController
        if isAlreadySelected {
            attemptToPopToRoot(ofFlow: viewController)
        }
        return true
    }

    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        fixTruncatedChildFrameCausedByNonTranslucentTabBar(in: tabBarController)
    }
}

private extension DefaultTabBarControllerDelegate {

    @discardableResult
    func attemptToPopToRoot(ofFlow viewController: UIViewController) -> Bool {
        guard let flowController = viewController as? _FlowController,
              let nestedNavController = flowController.children.first as? UINavigationController
        else {
            return false
        }
        // TODO: Should we add `if isAtRoot { scrollRootVCToTop() }` ???
        nestedNavController.popToRootViewController(animated: true)
        return true
    }

    func fixTruncatedChildFrameCausedByNonTranslucentTabBar(in tabBarController: UITabBarController) {
        guard !tabBarController.tabBar.isTranslucent else {
            return
        }
        tabBarController.tabBar.isTranslucent = true
        tabBarController.view.setNeedsLayout()
        tabBarController.view.layoutIfNeeded()
        tabBarController.tabBar.isTranslucent = false
    }
}
