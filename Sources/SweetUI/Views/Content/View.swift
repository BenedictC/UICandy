import UIKit


public typealias View = _View & ViewBodyProvider & ViewStateObserver


// MARK: - Implementation

open class _View: UIView {

    // MARK: Properties

    private var isUpdateViewPropertyNeeded = true


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

    open override func layoutSubviews() {
        super.layoutSubviews()

        if isUpdateViewPropertyNeeded {
            isUpdateViewPropertyNeeded = false

            // Perform update
            updateViewProperties()

            let didMutateViewStateDuringPropagation = isUpdateViewPropertyNeeded
            if didMutateViewStateDuringPropagation {
                (self as? ViewStateObserver)?.warnOfReentrantViewStatePropagation()
                isUpdateViewPropertyNeeded = false
            }
        }
    }


    // MARK: ViewState

    public func viewStateDidChange() {
        setNeedsUpdateViewProperties()
    }

    open func setNeedsUpdateViewProperties() {
        isUpdateViewPropertyNeeded = true
        setNeedsLayout()
    }

    open func updateViewProperties() {
        // Do nothing. For subclasses to override
    }
}


// MARK: - ViewBodyProvider

public extension _View {

    func arrangeBody(_ body: UIView, in container: UIView) {
        container.addAndFill(subview: body, overrideEdgesIgnoringSafeArea: nil)
    }
}


// MARK: - Compile-time conformance check

private class CompilationCheck: View {
    let body = UIView()
}
