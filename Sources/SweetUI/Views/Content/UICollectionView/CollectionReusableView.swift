import UIKit


// MARK: - CollectionReusableView

public typealias CollectionReusableView = _CollectionReusableView
                                        & ItemRepresentable
                                        & ViewBodyProvider
                                        & ViewStateHosting


open class _CollectionReusableView: UICollectionReusableView, ReuseIdentifiable {

    // MARK: Properties

    private var isPropertyUpdatedNeeded = true
    

    // MARK: Instance life cycle

    required public override init(frame: CGRect) {
        super.init(frame: frame)
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


    // MARK: View state

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
