import Foundation
import UIKit


// MARK: - CollectionViewCell

public typealias CollectionViewCell = _CollectionViewCell
                                    & ItemRepresentable
                                    & ViewBodyProvider
                                    & ViewStateHosting


open class _CollectionViewCell: UICollectionViewCell, ReuseIdentifiable {

    // MARK: Properties

    private lazy var onUpdatePropertiesHandlers = Set<OnUpdatePropertiesHandler>()

    public var bodyContainer: UIView { contentView }


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


    // MARK: View State

    public func addOnUpdatePropertiesHandler(withIdentifier identifier: AnyHashable?, action: @escaping () -> Void) {
        let handler = OnUpdatePropertiesHandler(identifier: identifier, handler: action)
        onUpdatePropertiesHandlers.insert(handler)
    }

    public func removeOnUpdatePropertiesHandler(withIdentifier identifier: AnyHashable) {
        onUpdatePropertiesHandlers = onUpdatePropertiesHandlers.filter { $0.identifier != identifier }
    }


    // MARK: Layout

    override open func layoutSubviews() {
        // TODO: Add iOS 26 support
        for handler in onUpdatePropertiesHandlers {
            handler.execute()
        }
        super.layoutSubviews()
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
