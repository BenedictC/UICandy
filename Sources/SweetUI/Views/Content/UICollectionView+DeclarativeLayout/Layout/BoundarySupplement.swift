import UIKit


public struct BoundarySupplement<Value> {

    // MARK: Types

    public typealias SupplementRegistrar = (UICollectionView) -> Void
    public typealias LayoutBoundarySupplementaryItemProvider = () -> NSCollectionLayoutBoundarySupplementaryItem
    public typealias SupplementProvider = (String, UICollectionView, IndexPath, Value) -> UICollectionReusableView?


    // MARK: Properties

    private let supplementRegistrar: SupplementRegistrar
    private let layoutBoundarySupplementaryItemProvider: LayoutBoundarySupplementaryItemProvider
    private let supplementProvider: SupplementProvider


    // MARK: Instance life cycle

    init(
        supplementRegistrar: @escaping SupplementRegistrar,
        layoutBoundarySupplementaryItemProvider: @escaping LayoutBoundarySupplementaryItemProvider,
        supplementProvider: @escaping SupplementProvider
    ) {
        self.supplementRegistrar = supplementRegistrar
        self.layoutBoundarySupplementaryItemProvider = layoutBoundarySupplementaryItemProvider
        self.supplementProvider = supplementProvider
    }


    // MARK: View registration

    func registerReusableViews(in collectionView: UICollectionView) {
        supplementRegistrar(collectionView)
    }


    // MARK: Layout creation

    func makeLayoutBoundarySupplementaryItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        layoutBoundarySupplementaryItemProvider()
    }


    // MARK: View creation

    func makeSupplementaryView(ofKind elementKind: String, for collectionView: UICollectionView, value: Value, at indexPath: IndexPath) -> UICollectionReusableView? {
        let expected = makeLayoutBoundarySupplementaryItem().elementKind
        guard elementKind == expected else { return nil }
        return supplementProvider(elementKind, collectionView, indexPath, value)
    }
}



// MARK: Factories

public extension BoundarySupplement {

    init<ViewType: UICollectionReusableView>(
        ofType viewType: ViewType.Type,
        size: NSCollectionLayoutSize,
        containerAnchor: NSCollectionLayoutAnchor,
        itemAnchor: NSCollectionLayoutAnchor?,
        extendsBoundary: Bool?,
        pinToVisibleBounds: Bool?,
        zIndex: Int?,
        configuration: @escaping (ViewType, Value) -> Void
    ) {
        let elementKind = UniqueIdentifier("\(Self.self) elementKind").value
        let reuseIdentifier = UniqueIdentifier("\(Self.self) reuseIdentifier").value

        self.init(
            supplementRegistrar: { collectionView in
                collectionView.register(ViewType.self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: reuseIdentifier)
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
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: reuseIdentifier, for: indexPath) as! ViewType
                configuration(view, value)
                return view
            }
        )
    }

    init<ViewType: CollectionReusableView>(
        ofType viewType: ViewType.Type,
        size: NSCollectionLayoutSize,
        containerAnchor: NSCollectionLayoutAnchor,
        itemAnchor: NSCollectionLayoutAnchor?,
        extendsBoundary: Bool?,
        pinToVisibleBounds: Bool?,
        zIndex: Int?
    ) where ViewType.Item == Value {
        let elementKind = UniqueIdentifier("\(Self.self) elementKind").value
        let reuseIdentifier = UniqueIdentifier("\(Self.self) reuseIdentifier").value
        
        self.init(
            supplementRegistrar: { collectionView in
                collectionView.register(ViewType.self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: reuseIdentifier)
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
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: reuseIdentifier, for: indexPath) as! ViewType
                view.item = value
                return view
            }
        )
    }
}


// MARK: - Content

public extension BoundarySupplement {

    init<Content: UIView>(
        size: NSCollectionLayoutSize,
        containerAnchor: NSCollectionLayoutAnchor,
        itemAnchor: NSCollectionLayoutAnchor?,
        extendsBoundary: Bool?,
        pinToVisibleBounds: Bool?,
        zIndex: Int?,
        contentBuilder: @escaping () -> Content
    ) {
        typealias ViewType = StaticContentReusableCollectionView<Content>
        let elementKind = UniqueIdentifier("\(Self.self) elementKind").value
        let reuseIdentifier = UniqueIdentifier("\(Self.self) reuseIdentifier").value
        self.init(
            supplementRegistrar: { collectionView in
                collectionView.register(ViewType.self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: reuseIdentifier)
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
                let cell = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: reuseIdentifier, for: indexPath) as! ViewType
                cell.setContentIfNeeded(contentBuilder: { _ in contentBuilder() })
                return cell
            }
        )
    }
}
