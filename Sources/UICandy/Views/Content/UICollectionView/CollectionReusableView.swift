import UIKit


// MARK: - CollectionReusableView

public typealias CollectionReusableView = _CollectionReusableView
                                        & ItemRepresentable
                                        & ViewBodyProvider
                                        & ViewStateObserver


open class _CollectionReusableView: UICollectionReusableView, ReuseIdentifiable {

    // MARK: Properties

    private var isUpdateViewPropertiesNeeded = true


    // MARK: Instance life cycle

    required public override init(frame: CGRect) {
        super.init(frame: frame)
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

extension _CollectionReusableView {

    public func arrangeBody(_ body: UIView, in container: UIView) {
        body.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(body)
        NSLayoutConstraint.activate([
            body.topAnchor.constraint(equalTo: container.topAnchor),
            body.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            // Priority is less than required to break cleanly if the content resizes without invalidating the
            // collectionView layout.
            body.bottomAnchor.constraint(equalTo: container.bottomAnchor).priority(.almostRequired),
            body.trailingAnchor.constraint(equalTo: container.trailingAnchor).priority(.almostRequired),
        ])
    }
}


// MARK: - Compile-time conformance check

private class CompilationCheck: CollectionReusableView {
    let body = UIView()
}
