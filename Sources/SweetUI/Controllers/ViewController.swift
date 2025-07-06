import UIKit


// MARK: - ViewController

public typealias ViewController = _ViewController & ViewControllerRequirements


// MARK: - Associated Types

public protocol ViewControllerRequirements: _ViewControllerRequirements, ViewStateHosting {
    associatedtype View: UIView
    
    var rootView: View { get }
}


public protocol _ViewControllerRequirements: _ViewController {
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

    private lazy var onUpdatePropertiesHandlers = Set<OnUpdatePropertiesHandler>()


    private let retainCycleAdvice =
    """
    Check that closures within the view that reference the view controller are weak, e.g.:
    - button.on(.primaryActionTriggered) { [weak self] _ in self?.submit() }
    - lazy var rootView = UICollectionView(snapshotCoordinator: snapshotCoordinator) { [weak self] ... }
    """


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
        let edgesToIgnore = UIView.edgesIgnoringSafeArea(for: rootView)
        let requiresContainer = edgesToIgnore != .all
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

        (self as? ViewStateHosting)?.initializeViewStateHosting()
    }


    // MARK: View State

    public func addOnUpdatePropertiesHandler(withIdentifier identifier: AnyHashable?, action: @escaping () -> Void) {
        let handler = OnUpdatePropertiesHandler(identifier: identifier, handler: action)
        onUpdatePropertiesHandlers.insert(handler)
    }

    public func removeOnUpdatePropertiesHandler(withIdentifier identifier: AnyHashable) {
        onUpdatePropertiesHandlers = onUpdatePropertiesHandlers.filter { $0.identifier != identifier }
    }


    // MARK: Layout

    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // TODO: Add iOS 26 support
        for handler in onUpdatePropertiesHandlers {
            handler.execute()
        }
    }
}
