import UIKit


public typealias View = _View & ViewBodyProvider & ViewStateObserver


// MARK: - Implementation

open class _View: UIView {

    // MARK: Properties

    private var isNeedsPropagateViewState = true


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

        if isNeedsPropagateViewState {
            isNeedsPropagateViewState = false

            // Perform update
            propagateViewState()

            let didMutateViewStateDuringPropagation = isNeedsPropagateViewState
            if didMutateViewStateDuringPropagation {
                (self as? ViewStateObserver)?.warnOfReentrantViewStatePropagation()
                isNeedsPropagateViewState = false
            }
        }
    }

    open func propagateViewState() {
        // Do nothing. For subclasses to override
    }
}


// MARK: - ViewState

extension _View {

    public func viewStateDidChange() {
        isNeedsPropagateViewState = true
        setNeedsLayout()
        if #available(iOS 26, *) {
            setNeedsUpdateProperties()
        }
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
