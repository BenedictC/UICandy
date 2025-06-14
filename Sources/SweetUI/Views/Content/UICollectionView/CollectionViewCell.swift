import Foundation
import UIKit


// MARK: - ConfigurableCollectionViewCell

public protocol ConfigurableCollectionViewCell: UICollectionViewCell, ReusableViewConfigurable {
}


// MARK: - CollectionViewCell

public typealias CollectionViewCell = _CollectionViewCell & ViewBodyProvider & ConfigurableCollectionViewCell


open class _CollectionViewCell: UICollectionViewCell, ReuseIdentifiable {

    // MARK: Properties

    public var bodyContainer: UIView { contentView }


    // MARK: Instance life cycle

    public required override init(frame: CGRect) {
        super.init(frame: frame)
        Self.initializeBodyHosting(of: self)
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
