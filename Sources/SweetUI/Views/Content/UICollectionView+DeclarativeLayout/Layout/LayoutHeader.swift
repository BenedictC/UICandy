

public struct LayoutHeader {

    // MARK: Types

    public typealias SupplementRegistrar = (UICollectionView) -> Void
    public typealias SupplementProvider = (String, UICollectionView, IndexPath, Void) -> UICollectionReusableView?


    // MARK: Properties

    static let elementKind = UniqueIdentifier("LayoutHeader").value
    var elementKind: String { Self.elementKind }
    private let supplementRegistrar: SupplementRegistrar
    private let supplementProvider: SupplementProvider


    // MARK: Instance life cycle

    init(
        supplementRegistrar: @escaping SupplementRegistrar,
        supplementProvider: @escaping SupplementProvider
    ) {
        self.supplementRegistrar = supplementRegistrar
        self.supplementProvider = supplementProvider
    }


    // MARK:  BoundarySupplement

    public func registerReusableViews(in collectionView: UICollectionView) {
        supplementRegistrar(collectionView)
    }

    public func makeLayoutBoundarySupplementaryItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(44)
        )
        let layoutItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: size,
            elementKind: elementKind,
            alignment: .top,
            absoluteOffset: .zero
        )
        return layoutItem
    }

    public func makeSupplementaryView(ofKind elementKind: String, for collectionView: UICollectionView, indexPath: IndexPath, value: Void) -> UICollectionReusableView? {
        guard elementKind == self.elementKind else { return nil }
        return supplementProvider(elementKind, collectionView, indexPath, value)
    }

    public func asBoundarySupplement() -> BoundarySupplement<Void> {
        return BoundarySupplement(
            supplementRegistrar: registerReusableViews(in:),
            layoutBoundarySupplementaryItemProvider: makeLayoutBoundarySupplementaryItem,
            supplementProvider: makeSupplementaryView(ofKind:for:indexPath:value:)
        )
    }
}


// MARK: - Inits

public extension LayoutHeader {

    init<T: UICollectionReusableView>(
        ofType viewType: T.Type,
        configuration: @escaping (T) -> Void = { _ in }
    ) {
        let elementKind = Self.elementKind
        let reuseIdentifier = UniqueIdentifier("\(Self.self)").value

        self.init(
            supplementRegistrar: { collectionView in
                collectionView.register(viewType, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: reuseIdentifier)
            },
            supplementProvider: { reuseIdentifier, collectionView, indexPath, sectionIdentifier in
                let view = collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: reuseIdentifier,
                    for: indexPath
                ) as! T
                configuration(view)
                return view
            }
        )
    }

    init<Content: UIView>(
        contentBuilder: @escaping () -> Content
    ) {
        typealias ViewType = StaticContentReusableCollectionView<Content>
        let elementKind = Self.elementKind
        let reuseIdentifier = UniqueIdentifier("\(Self.self) reuseIdentifier").value
        
        self.supplementRegistrar = { collectionView in
            collectionView.register(ViewType.self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: reuseIdentifier)
        }
        self.supplementProvider = { _, collectionView, indexPath, sectionIdentifier in
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: reuseIdentifier, for: indexPath) as! ViewType
            cell.setContentIfNeeded(contentBuilder: { _ in contentBuilder() })
            return cell
        }
    }
}
