import UIKit


public typealias View = _View & ViewBodyProvider & ViewStateObserver


// MARK: - Implementation

open class _View: UIView {

    // MARK: Properties

    private var isUpdateViewPropertiesNeeded = true


    // MARK: Instance life cycle

    public init() {
        super.init(frame: .zero)
        Self.initializeBodyHosting(of: self)
        (self as? ViewStateObserver)?.initializeViewStateObserving()
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: Layout

    public func viewStateDidChange() {
        setNeedsUpdateViewProperties()
        if #available(iOS 26, *) {
            setNeedsUpdateProperties()
        }
    }

    open override func updateConstraints() {
        performUpdateViewProperties()
        super.updateConstraints()
    }

    @available(iOS, deprecated: 26, message: "Call setNeedsUpdateProperties() instead.")
    open func setNeedsUpdateViewProperties() {
        isUpdateViewPropertiesNeeded = true
        setNeedsUpdateConstraints()
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


// MARK: - ViewBodyProvider

public extension _View {

    func arrangeBody(_ body: UIView, in container: UIView) {
        container.addAndFill(subview: body, edgesIgnoringSafeArea: .all)
    }
}


// MARK: - Compile-time conformance check

private class CompilationCheck: View {
    let body = UIView()
}
