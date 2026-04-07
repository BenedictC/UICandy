import UIKit


// MARK: - CompositeSection

@available(iOS 14, *)
@MainActor
public struct CompositeSection<SectionIdentifier: Hashable, ItemIdentifier> {

    // MARK: Properties

    let predicate: ((SectionIdentifier) -> Bool)
    private let orthogonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior?
    private let interGroupSpacing: CGFloat?
    private let contentInsets: NSDirectionalEdgeInsets?
    private let contentInsetsReference: UIContentInsetsReference?
    private let supplementaryContentInsetsReference: UIContentInsetsReference?
    private let visibleItemsInvalidationHandler: NSCollectionLayoutSectionVisibleItemsInvalidationHandler?
    private let boundarySupplements: [BoundarySupplement<SectionIdentifier>]
    private let background: Background?
    private let group: any Group<ItemIdentifier>



    // MARK: Instance life cycle
    
    init(
        predicate: @escaping ((SectionIdentifier) -> Bool),
        orthogonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior?,
        interGroupSpacing: CGFloat?,
        contentInsets: NSDirectionalEdgeInsets?,
        contentInsetsReference: UIContentInsetsReference?,
        supplementaryContentInsetsReference: UIContentInsetsReference?,
        visibleItemsInvalidationHandler: NSCollectionLayoutSectionVisibleItemsInvalidationHandler?,
        background: Background?,
        boundarySupplements: [BoundarySupplement<SectionIdentifier>],
        group: any Group<ItemIdentifier>
    ) {
        self.predicate = predicate
        self.orthogonalScrollingBehavior = orthogonalScrollingBehavior
        self.interGroupSpacing = interGroupSpacing
        self.contentInsets = contentInsets
        self.contentInsetsReference = contentInsetsReference
        self.supplementaryContentInsetsReference = supplementaryContentInsetsReference
        self.visibleItemsInvalidationHandler = visibleItemsInvalidationHandler
        self.background = background
        self.boundarySupplements = boundarySupplements
        self.group = group
    }


    // MARK: View registration

    func registerDecorationViews(in layout: UICollectionViewLayout) {
        if let background {
            background.registerDecorationView(in: layout)
        }
    }

    func registerReusableViews(in collectionView: UICollectionView) {
        // Register the cells
        group.registerReusableViews(in: collectionView)
        // Section supplementary
        for boundarySupplement in boundarySupplements {
            boundarySupplement.registerReusableViews(in: collectionView)
        }
    }


    // MARK: Layout creation

    func makeCompositionalLayoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let group = group.makeLayoutGroup(environment: environment)

        let section = NSCollectionLayoutSection(group: group)
        if let orthogonalScrollingBehavior {
            section.orthogonalScrollingBehavior = orthogonalScrollingBehavior
        }
        if let interGroupSpacing {
            section.interGroupSpacing = interGroupSpacing
        }
        if let contentInsets {
            section.contentInsets = contentInsets
        }
        if let contentInsetsReference {
            section.contentInsetsReference = contentInsetsReference
        }
        if #available(iOS 16.0, *) {
            if let supplementaryContentInsetsReference {
                section.supplementaryContentInsetsReference = supplementaryContentInsetsReference
            }
        }
        if let visibleItemsInvalidationHandler {
            section.visibleItemsInvalidationHandler = visibleItemsInvalidationHandler
        }

        let boundarySupplementaryItem = boundarySupplements
            .map { $0.makeLayoutBoundarySupplementaryItem() }

        section.boundarySupplementaryItems = boundarySupplementaryItem

        if let background {
            section.decorationItems = [background.makeLayoutDecorationItem()]
        }

        return section
    }


    // MARK: View creation

    func makeSupplementaryView(forElementKind elementKind: String, in collectionView: UICollectionView, indexPath: IndexPath, sectionIdentifier: SectionIdentifier) -> UICollectionReusableView? {
        for boundarySupplement in boundarySupplements {
            let view = boundarySupplement.makeSupplementaryView(ofKind: elementKind, for: collectionView, value: sectionIdentifier, at: indexPath)
            if let view {
                return view
            }
        }
        return nil
    }

    func makeSupplementaryView(forElementKind elementKind: String, in collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: ItemIdentifier) -> UICollectionReusableView? {
        group.makeSupplementaryView(ofKind: elementKind, for: collectionView, itemIdentifier: itemIdentifier, at: indexPath)
    }

    func makeCell(for collectionView: UICollectionView, itemIdentifier: ItemIdentifier, at indexPath: IndexPath) -> UICollectionViewCell {
        group.makeCell(for: collectionView, itemIdentifier: itemIdentifier, at: indexPath)
    }
}


// MARK: - Factories

@available(iOS 14, *)
public extension CompositeSection {

    // with trailing closure
    init(
        predicate: @escaping ((SectionIdentifier) -> Bool) = { _ in true },
        orthogonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior? = nil,
        contentInsets: NSDirectionalEdgeInsets? = nil,
        contentInsetsReference: UIContentInsetsReference? = nil,
        interGroupSpacing: CGFloat? = nil,
        visibleItemsInvalidationHandler: NSCollectionLayoutSectionVisibleItemsInvalidationHandler? = nil,
        supplementaryContentInsetsReference: UIContentInsetsReference? = nil,
        @ArrayBuilder<BoundarySupplement<SectionIdentifier>>
        boundarySupplements: () -> [BoundarySupplement<SectionIdentifier>] = { [] },
        background: Background? = nil,
        group: () -> some Group<ItemIdentifier>
    ) {
        self = CompositeSection(
            predicate: predicate,
            orthogonalScrollingBehavior: orthogonalScrollingBehavior,
            interGroupSpacing: interGroupSpacing,
            contentInsets: contentInsets,
            contentInsetsReference: contentInsetsReference,
            supplementaryContentInsetsReference: supplementaryContentInsetsReference,
            visibleItemsInvalidationHandler: visibleItemsInvalidationHandler,
            background: background,
            boundarySupplements: boundarySupplements(),
            group: group().eraseToAnyGroup()
        )
    }
}


// MARK: With identifier

@available(iOS 14, *)
public extension CompositeSection {

    // with trailing closure
    init(
        identifier: SectionIdentifier,
        orthogonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior? = nil,
        contentInsets: NSDirectionalEdgeInsets? = nil,
        contentInsetsReference: UIContentInsetsReference? = nil,
        interGroupSpacing: CGFloat? = nil,
        visibleItemsInvalidationHandler: NSCollectionLayoutSectionVisibleItemsInvalidationHandler? = nil,
        supplementaryContentInsetsReference: UIContentInsetsReference? = nil,
        @ArrayBuilder<BoundarySupplement<SectionIdentifier>>
        boundarySupplements: () -> [BoundarySupplement<SectionIdentifier>] = { [] },
        background: Background? = nil,
        group: () -> some Group<ItemIdentifier>
    ) {
        self.init(
            predicate: { $0 == identifier },
            orthogonalScrollingBehavior: orthogonalScrollingBehavior,
            interGroupSpacing: interGroupSpacing,
            contentInsets: contentInsets,
            contentInsetsReference: contentInsetsReference,
            supplementaryContentInsetsReference: supplementaryContentInsetsReference,
            visibleItemsInvalidationHandler: visibleItemsInvalidationHandler,
            background: background,
            boundarySupplements: boundarySupplements(),
            group: group()
        )
    }
}
