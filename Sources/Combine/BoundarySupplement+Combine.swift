import Combine


// MARK: - Published

public extension BoundarySupplement {

    init(
        size: NSCollectionLayoutSize,
        containerAnchor: NSCollectionLayoutAnchor,
        itemAnchor: NSCollectionLayoutAnchor?,
        extendsBoundary: Bool?,
        pinToVisibleBounds: Bool?,
        zIndex: Int?,
        contentBuilder: @escaping (_ binding: any CurrentValuePublisher<Value, Never>) -> UIView
    ) {
        typealias CellType = ValuePublishingCell<Value>
        let elementKind = UniqueIdentifier("\(Self.self) elementKind").value
        let reuseIdentifier = UniqueIdentifier("\(Self.self) reuseIdentifier").value
        self.init(
            supplementRegistrar: { collectionView in
                collectionView.register(CellType.self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: reuseIdentifier)
            },
            layoutBoundarySupplementaryItemProvider: {
                let item = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: size,
                    elementKind: elementKind,
                    containerAnchor: containerAnchor,
                    itemAnchor: itemAnchor ?? containerAnchor
                )
                extendsBoundary.flatMap { item.extendsBoundary = $0 }
                pinToVisibleBounds.flatMap { item.pinToVisibleBounds = $0 }
                zIndex.flatMap { item.zIndex = $0 }
                return item
            },
            supplementProvider: { _, collectionView, indexPath, value in
                let cell = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: reuseIdentifier, for: indexPath) as! CellType
                cell.initialize(bodyProvider: { contentBuilder($1) })
                cell.configure(withValue: value)
                return cell
            }
        )
    }
}

