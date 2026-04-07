import UIKit


// MARK: - ReusableViewConfigurable

public extension Supplement {

    init<V: UICollectionViewCell & ItemRepresentable>(
        _ viewClass: V.Type,
        size: NSCollectionLayoutSize? = nil,
        containerAnchor: NSCollectionLayoutAnchor,
        itemAnchor: NSCollectionLayoutAnchor? = nil
    ) {
        let elementKind = UniqueIdentifier("SupplementaryView").value
        let reuseIdentifier = UniqueIdentifier("\(Self.self)").value
        self.init(
            elementKind: elementKind,
            supplementRegistrar: { collectionView in
                collectionView.register(viewClass, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: reuseIdentifier)
            },
            layoutSupplementaryItemProvider: { defaultSize in
                let size = size ?? defaultSize
                if let itemAnchor {
                    return NSCollectionLayoutSupplementaryItem(layoutSize: size, elementKind: elementKind, containerAnchor: containerAnchor, itemAnchor: itemAnchor)
                } else {
                    return NSCollectionLayoutSupplementaryItem(layoutSize: size, elementKind: elementKind, containerAnchor: containerAnchor)
                }
            },
            supplementProvider: { eKind, collectionView, indexPath, ItemIdentifier in
                guard elementKind == eKind else { return nil }
                return collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: reuseIdentifier, for: indexPath)
            }
        )
    }
}


// MARK: - UICollectionViewListCell

@available(iOS 14, *)
public extension Supplement {

    init(
        elementKind optionalElementKind: String? = nil,
        size: NSCollectionLayoutSize? = nil,
        containerAnchor: NSCollectionLayoutAnchor,
        itemAnchor: NSCollectionLayoutAnchor? = nil,
        configuration: @escaping (UICollectionViewListCell, Value) -> Void)
    {
        let viewClass = UICollectionViewListCell.self
        let elementKind = optionalElementKind ?? UniqueIdentifier("SupplementaryView").value
        let reuseIdentifier = UniqueIdentifier("\(Self.self)").value
        
        self.init(
            elementKind: elementKind,
            supplementRegistrar: { collectionView in
                collectionView.register(viewClass, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: reuseIdentifier)
            },
            layoutSupplementaryItemProvider: { defaultSize in
                let size = size ?? defaultSize
                if let itemAnchor {
                    return NSCollectionLayoutSupplementaryItem(layoutSize: size, elementKind: elementKind, containerAnchor: containerAnchor, itemAnchor: itemAnchor)
                } else {
                    return NSCollectionLayoutSupplementaryItem(layoutSize: size, elementKind: elementKind, containerAnchor: containerAnchor)
                }
            },
            supplementProvider: { eKind, collectionView, indexPath, ItemIdentifier in
                guard eKind == elementKind else { return nil }
                let cell = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: reuseIdentifier, for: indexPath) as! UICollectionViewListCell
                configuration(cell, ItemIdentifier)
                return cell
            }
        )
    }
}
