import UIKit


// MARK: - ViewController

public typealias ViewController = _ViewController & ViewControllerRequirements


// MARK: - Associated Types

@MainActor
public protocol ViewControllerRequirements: _ViewControllerRequirements {
    associatedtype View: UIView
    
    var rootView: View { get }
}


@MainActor
public protocol _ViewControllerRequirements: _ViewController, ViewStateObserver {
    var _rootView: UIView { get }
    func awake()
}


// MARK: - Implementation

public extension ViewControllerRequirements {
    var _rootView: UIView { rootView }
    func awake() { }
}


open class _ViewController: UIViewController {

    // MARK: Properties

    private let retainCycleAdvice =
    """
    Check that closures within the view that reference the view controller are weak, e.g.:
    - button.on(.primaryActionTriggered) { [weak self] _ in self?.submit() }
    - lazy var rootView = UICollectionView(snapshotCoordinator: snapshotCoordinator) { [weak self] ... }
    """

    private var isUpdateViewPropertiesNeeded = true


    // MARK: Instance life cycle

    public init() {
        super.init(nibName: nil, bundle: nil)

        guard let owner = self as? _ViewControllerRequirements else {
            preconditionFailure("_ViewController must conform to _ViewControllerRequirements")
        }
        // awake
        detectPotentialRetainCycle(of: self, advice: retainCycleAdvice) { owner.awake() }
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: View life cycle

    @available(*, deprecated, message: "Use viewDidLoad to configure the view.")
    override public func loadView() {
        guard let owner = self as? _ViewControllerRequirements else {
            preconditionFailure("_ViewController must conform to _ViewControllerRequirements")
        }
        // If the view ignores all safe areas then it can be used as the self.view directly
        let rootView = detectPotentialRetainCycle(of: self, advice: retainCycleAdvice) { owner._rootView }
        let (requiresContainer, edgesToIgnore) = edgesIgnoringSafeArea(for: rootView)
        if requiresContainer {
            let container = rootView.ignoresSafeArea(edges: edgesToIgnore)
            self.view = container
        } else {
            self.view = rootView
        }

        let shouldSetBackground = self.view.backgroundColor == nil
        if shouldSetBackground {
            self.view.backgroundColor = .systemBackground
        }

        (self as? ViewStateObserver)?.initializeViewStateObserving()
    }

    private func edgesIgnoringSafeArea(for view: UIView) -> (requiresContainer: Bool, edgesToIgnore: UIRectEdge) {
        if let view = view as? EdgesIgnoringSafeAreaSupporting, view.safeAreaIgnoringRegions.contains(.container) {
            return (false, view.edgesIgnoringSafeArea)
        }
        if view is UIScrollView {
            return (false, .all)
        }
        if let subview = view.subviews.first {
            return edgesIgnoringSafeArea(for: subview)
        }
        return (true, [])
    }


    // MARK: ViewState

    public func viewStateDidChange() {
        setNeedsUpdateViewProperties()
        if #available(iOS 26, *) {
            setNeedsUpdateProperties()
        }
    }


    // MARK: Layout

    open override func updateViewConstraints() {
        performUpdateViewProperties()
        super.updateViewConstraints()
    }

    @available(iOS, deprecated: 26, message: "Call setNeedsUpdateProperties() instead.")
    open func setNeedsUpdateViewProperties() {
        isUpdateViewPropertiesNeeded = true
        view.setNeedsUpdateConstraints()
    }

    open func updateViewPropertiesIfNeeded() {
        performUpdateViewProperties()
    }

    @available(iOS, deprecated: 26, message: "Override updateProperties() instead.")
    open func updateViewProperties() {
        // Do nothing. For subclasses to override
    }

    private func performUpdateViewProperties() {
        guard isUpdateViewPropertiesNeeded else {
            return
        }
        isUpdateViewPropertiesNeeded = false

        // Perform update
        updateViewProperties()

        let didMutateViewStateDuringPropagation = isUpdateViewPropertiesNeeded
        if didMutateViewStateDuringPropagation {
            (self as? ViewStateObserver)?.warnOfReentrantViewStatePropagation()
            isUpdateViewPropertiesNeeded = false
        }
    }
}


// MARK: - Compile-time conformance check

@available(iOS 15, *)
private class CompilationCheck: ViewController {
    
    let rootView = UIView() 
}
