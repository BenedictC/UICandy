import UIKit


// MARK: - CollectionViewCell

@available(iOS 14, *)
public typealias CollectionViewCell = _CollectionViewCell
                                    & ItemRepresentable
                                    & ViewBodyProvider
                                    & ViewStateObserver

@available(iOS 14, *)
open class _CollectionViewCell: UICollectionViewCell, ReuseIdentifiable {

    // MARK: Properties

    public var bodyContainer: UIView { contentView }
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

    open override func updateConfiguration(using state: UICellConfigurationState) {
        performUpdateViewProperties()
        super.updateConfiguration(using: state)
    }

    @available(iOS, deprecated: 26, message: "Call setNeedsUpdateProperties() instead.")
    open func setNeedsUpdateViewProperties() {
        isUpdateViewPropertiesNeeded = true
        setNeedsUpdateConfiguration()
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

@available(iOS 14, *)
extension _CollectionViewCell {

    public func arrangeBody(_ body: UIView, in container: UIView) {
        body.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(body)
        NSLayoutConstraint.activate([
            body.topAnchor.constraint(equalTo: container.safeAreaLayoutGuide.topAnchor),
            body.leadingAnchor.constraint(equalTo: container.safeAreaLayoutGuide.leadingAnchor),
            // Priority is less than required to break cleanly if the content resizes without invalidating the
            // collectionView layout.
            body.bottomAnchor.constraint(equalTo: container.safeAreaLayoutGuide.bottomAnchor).priority(.almostRequired),
            body.trailingAnchor.constraint(equalTo: container.safeAreaLayoutGuide.trailingAnchor).priority(.almostRequired),
        ])
    }
}


// MARK: - Compile-time conformance check

@available(iOS 14, *)
private class CompilationCheck: CollectionViewCell {
    let body = UIView()
}
