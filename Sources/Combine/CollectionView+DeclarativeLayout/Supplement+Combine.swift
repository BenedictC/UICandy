import UIKit
import Combine


// MARK: - ValuePublishingCell

public extension Supplement {

    init(
        size: NSCollectionLayoutSize? = nil,
        containerAnchor: NSCollectionLayoutAnchor,
        itemAnchor: NSCollectionLayoutAnchor? = nil,
        body bodyProvider: @escaping (any CurrentValuePublisher<Value, Never>) -> UIView)
    {
        let viewClass = ValuePublishingCell<Value>.self
        let elementKind = UniqueIdentifier("SupplementaryView").value

        self.init(
            elementKind: elementKind,
            supplementRegistrar: { collectionView in
                collectionView.register(viewClass, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: elementKind)
            },
            layoutSupplementaryItemProvider: { defaultSize in
                let size = size ?? defaultSize
                if let itemAnchor {
                    return NSCollectionLayoutSupplementaryItem(layoutSize: size, elementKind: elementKind, containerAnchor: containerAnchor, itemAnchor: itemAnchor)
                } else {
                    return NSCollectionLayoutSupplementaryItem(layoutSize: size, elementKind: elementKind, containerAnchor: containerAnchor)
                }
            },
            supplementProvider: { eKind, collectionView, indexPath, itemIdentifier in
                guard elementKind == eKind else { return nil }
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: elementKind, for: indexPath) as! ValuePublishingCell<Value>
                view.initialize(bodyProvider: {_, publisher in bodyProvider(publisher) })
                view.configure(withValue: itemIdentifier)
                return view
            }
        )
    }
}
