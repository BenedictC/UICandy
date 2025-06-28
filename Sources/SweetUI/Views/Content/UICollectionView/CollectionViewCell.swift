import Foundation
import UIKit


// MARK: - ConfigurableCollectionViewCell

public protocol ConfigurableCollectionViewCell: UICollectionViewCell, ReusableViewConfigurable {
}


// MARK: - CollectionViewCell

public typealias CollectionViewCell = _CollectionViewCell & ConfigurableCollectionViewCell & ViewBodyProvider & ViewStateHosting


open class _CollectionViewCell: UICollectionViewCell, ReuseIdentifiable {

    // MARK: Properties

    public lazy var viewStateObservations = [ViewStateObservation]()

    public var bodyContainer: UIView { contentView }


    // MARK: Instance life cycle

    required public override init(frame: CGRect) {
        super.init(frame: frame)
        Self.initializeBodyHosting(of: self)
        (self as? ViewStateHosting)?.initializeViewStateObserving()
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @available(iOS 14.0, *)
    override open func updateConfiguration(using state: UICellConfigurationState) {
        (self as? ViewStateHosting)?.performViewStateObservationUpdates()
        super.updateConfiguration(using: state)
    }

    override open func layoutSubviews() {
        if #available(iOS 14.0, *) {
            // do nothing, handled by updateConfiguration(using:)
        } else {
            (self as? ViewStateHosting)?.performViewStateObservationUpdates()
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
