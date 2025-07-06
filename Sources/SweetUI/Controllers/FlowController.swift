import UIKit


// MARK: - FlowController

public typealias FlowController = _FlowController & FlowControllerRequirements


// MARK: - Associated Types

public protocol FlowControllerRequirements: ViewControllerRequirements, _FlowControllerRequirements {

    associatedtype ContainerViewController: UIViewController = UINavigationController
    associatedtype RootViewController: UIViewController
    associatedtype View = UIView

    var containerViewController: ContainerViewController { get }
    var rootViewController: RootViewController { get } // containerVC is used if none is set
}


// MARK: - Core Implementation

public protocol _FlowControllerRequirements: _FlowController, _ViewControllerRequirements {
    
    var _containerViewController: UIViewController { get }
    var _rootViewController: UIViewController { get }
    var childViewContainer: UIView { get }
}


public extension FlowControllerRequirements {

    var _containerViewController: UIViewController { containerViewController }
    var _rootViewController: UIViewController { rootViewController }
    var childViewContainer: UIView { rootView }

    var _rootView: UIView { rootView }
    var rootView: View {
        guard isViewLoaded else {
            return View()
        }
        guard let view = view as? View else {
            preconditionFailure("\(type(of: self)).view is of unexpected type. Expected \(View.self) but found \(type(of: view)).")
        }
        return view
    }
}


open class _FlowController: _ViewController {

    fileprivate var defaultContainerViewController: UIViewController?

    @available(*, unavailable, message: "Use viewDidLoad to configure the view.")
    override public func loadView() {
        guard let flow = self as? _FlowControllerRequirements else {
            preconditionFailure("_FlowController subclasses must conform to _FlowControllerRequirements.")
        }

        self.view = flow._rootView

        let childVC = flow._containerViewController
        guard let childView = childVC.view else {
            preconditionFailure("ViewController.view must not be nil.")
        }
        childVC.willMove(toParent: self)

        let container = flow.childViewContainer
        container.addSubview(childView)
        childView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            childView.topAnchor.constraint(equalTo: container.topAnchor),
            childView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            childView.leftAnchor.constraint(equalTo: container.leftAnchor),
            childView.rightAnchor.constraint(equalTo: container.rightAnchor),
        ])

        addChild(childVC)
    }
}


// MARK: - Additions

/// If a rootVC is not specified then use the containerVC.
public extension FlowControllerRequirements where Self: _FlowController, RootViewController == UIViewController {

    var rootViewController: RootViewController {
        _containerViewController
    }
}


// MARK: - UINavigationController additions

/// Creates and configures a  NavigationController if one is not explicit set. Allows the vc to be declared with only the RootViewController
public extension FlowControllerRequirements where Self: _FlowController, ContainerViewController: UINavigationController {

    var containerViewController: ContainerViewController {
        // If we all ready have the container then we're done
        if let defaultContainerViewController = defaultContainerViewController as? ContainerViewController {
            return defaultContainerViewController
        }
        // Create and store the container
        let containerViewController = ContainerViewController()
        defaultContainerViewController = containerViewController
        // Configure with the root
        guard rootViewController != containerViewController else {
            preconditionFailure("No rootViewController provided. FlowController class must implement either `containerViewController` or `rootViewController`. \(type(of: self)) provides neither.")
        }
        containerViewController.setViewControllers([rootViewController], animated: false)
        return containerViewController
    }
}


/// Core navigation methods
public extension FlowControllerRequirements where ContainerViewController: UINavigationController {

    func push(_ viewController: UIViewController, animated: Bool) {
        containerViewController.pushViewController(viewController, animated: animated)
    }

    func pop(animated: Bool) {
        containerViewController.popViewController(animated: animated)
    }

    func pop(to child: UIViewController, animated: Bool) {
        containerViewController.popToViewController(child, animated: animated)
    }

    func popToRoot(animated: Bool) {
        containerViewController.popToRootViewController(animated: animated)
    }
}
