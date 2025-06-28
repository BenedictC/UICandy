import UIKit


public struct SectionHeader<SectionIdentifier> {

    // MARK: Types

    public typealias SupplementRegistrar = (UICollectionView) -> Void
    public typealias SupplementProvider = (String, UICollectionView, IndexPath, SectionIdentifier) -> UICollectionReusableView?


    // MARK: Properties

    static var elementKind: String { UICollectionView.elementKindSectionHeader }
    let elementKind = Self.elementKind
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

    public func makeSupplementaryView(ofKind elementKind: String, for collectionView: UICollectionView, indexPath: IndexPath, value: SectionIdentifier) -> UICollectionReusableView? {
        guard elementKind == self.elementKind else { return nil }
        return supplementProvider(elementKind, collectionView, indexPath, value)
    }

    public func asBoundarySupplement() -> BoundarySupplement<SectionIdentifier> {
        return BoundarySupplement(
            supplementRegistrar: registerReusableViews(in:),
            layoutBoundarySupplementaryItemProvider: makeLayoutBoundarySupplementaryItem,
            supplementProvider: makeSupplementaryView(ofKind:for:indexPath:value:)
        )
    }
}


// MARK: - Inits

public extension SectionHeader {

    init<T: UICollectionReusableView>(
        ofType viewType: T.Type,
        configuration: @escaping (T, SectionIdentifier) -> Void = { _, _ in }
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
                configuration(view, sectionIdentifier)
                return view
            }
        )
    }

    init<T: CollectionReusableView>(ofType viewType: T.Type) where T.Item == SectionIdentifier {
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
                view.item = sectionIdentifier
                return view
            }
        )
    }

    init<T: UIView>(content: @escaping () -> T) {
        typealias ViewType = StaticContentReusableCollectionView<T>
        let elementKind = Self.elementKind
        let reuseIdentifier = UniqueIdentifier("\(Self.self)").value
        
        self.init(
            supplementRegistrar: { collectionView in
                collectionView.register(ViewType.self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: reuseIdentifier)
            },
            supplementProvider: { reuseIdentifier, collectionView, indexPath, sectionIdentifier in
                let view = collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: reuseIdentifier,
                    for: indexPath
                ) as! ViewType
                view.setContentIfNeeded(contentBuilder: { _ in content() })
                return view
            }
        )
    }
}
