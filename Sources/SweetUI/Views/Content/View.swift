import UIKit


public typealias View = _View & ViewBodyProvider & ViewStateHosting


// MARK: - Implementation

open class _View: UIView {

    // MARK: Properties

    private var isPropertyUpdatedNeeded = true


    // MARK: Instance life cycle
    
    public init() {
        super.init(frame: .zero)
        Self.initializeBodyHosting(of: self)
        (self as? ViewStateHosting)?.initializeViewStateHosting()
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: Layout

    open override func layoutSubviews() {
        super.layoutSubviews()
        updatePropertiesIfNeeded()
    }


    // MARK: ViewState

    open func updateProperties() {
        // Do nothing, subclasses should override
    }

    public func viewStateDidChange() {
        isPropertyUpdatedNeeded = true
        setNeedsLayout()
    }

    public func updatePropertiesIfNeeded() {
        guard isPropertyUpdatedNeeded else { return }
        isPropertyUpdatedNeeded = false

        updateProperties()

        if isPropertyUpdatedNeeded {
            (self as? ViewStateHosting)?.warnOfReentrantUpdateProperties()
            isPropertyUpdatedNeeded = false
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
