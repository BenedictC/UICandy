import UIKit


// MARK: - CollectionViewCell

public typealias CollectionViewCell = _CollectionViewCell
                                    & ItemRepresentable
                                    & ViewBodyProvider
                                    & ViewStateObserver


open class _CollectionViewCell: UICollectionViewCell, ReuseIdentifiable {

    // MARK: Properties

    public var bodyContainer: UIView { contentView }
    private var isUpdateViewPropertyNeeded = true


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

    @available(iOS 14, *)
    open override func updateConfiguration(using configuration: UICellConfigurationState) {
        super.updateConfiguration(using: configuration)

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
        if #available(iOS 14, *) {
            setNeedsUpdateConfiguration()
        } else {
            updateViewProperties()
        }
    }

    open func updateViewProperties() {
        // Do nothing. For subclasses to override
    }
}


// MARK: - ViewBodyProvider

extension _CollectionViewCell {

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

private class CompilationCheck: CollectionViewCell {
    let body = UIView()
}
