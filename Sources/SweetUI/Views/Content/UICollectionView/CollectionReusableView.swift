import UIKit


// MARK: - CollectionReusableView

public typealias CollectionReusableView = _CollectionReusableView
                                        & ItemRepresentable
                                        & ViewBodyProvider
                                        & ViewStateObserver


open class _CollectionReusableView: UICollectionReusableView, ReuseIdentifiable {

    // MARK: Properties

    private var isNeedsPropagateViewState = true
    

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


    // MARK: ViewState

    public func viewStateDidChange() {
        isNeedsPropagateViewState = true
        setNeedsLayout()
    }

    open func propagateViewState() {
        // Do nothing. For subclasses to override
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
