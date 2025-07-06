import UIKit


// MARK: - CompositeLayout

@available(iOS 14, *)
public struct CompositeLayout<SectionIdentifier: Hashable, ItemIdentifier: Hashable>: CollectionViewLayoutStrategy {

    public let behaviors: CollectionViewLayoutBehaviors<SectionIdentifier, ItemIdentifier>
    let background: LayoutBackground?
    let boundarySupplements: [BoundarySupplement<Void>]
    let sections: [CompositeSection<SectionIdentifier, ItemIdentifier>]

    public func registerReusableViews(in collectionView: UICollectionView, layout: UICollectionViewLayout) {
        if let background = self.background {
            collectionView.backgroundView = background.view
        }
        for boundarySupplement in boundarySupplements {
            boundarySupplement.registerReusableViews(in: collectionView)
        }
        for section in self.sections {
            section.registerDecorationViews(in: layout)
            section.registerReusableViews(in: collectionView)
        }
    }

    public func makeLayout(dataSource: UICollectionViewDiffableDataSource<SectionIdentifier, ItemIdentifier>) -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.boundarySupplementaryItems = boundarySupplements.map { $0.makeLayoutBoundarySupplementaryItem() }

        return UICollectionViewCompositionalLayout(
            sectionProvider: { [weak dataSource] sectionIndex, environment in
                guard let dataSource else {
                    preconditionFailure("DataSource is no longer available.")
                }
                guard let sectionIdentifier = dataSource.sectionIdentifier(forSectionAtIndex: sectionIndex) else {
                    preconditionFailure("Invalid section index")
                }
                let section = self.makeSection(for: sectionIdentifier)
                return section.makeCompositionalLayoutSection(environment: environment)
            },
            configuration: configuration)
    }

    private func makeSection(for sectionIdentifier: SectionIdentifier) -> CompositeSection<SectionIdentifier, ItemIdentifier> {
        // Check sections with predicates for a match
        if let section = sections.first(where: { $0.predicate(sectionIdentifier) }) {
            return section
        }
        preconditionFailure("No sections to represent sectionIdentifier '\(sectionIdentifier)'.")
    }

    public func makeCell(for collectionView: UICollectionView, itemIdentifier: ItemIdentifier, in sectionIdentifier: SectionIdentifier, at indexPath: IndexPath) -> UICollectionViewCell {
        let section = self.makeSection(for: sectionIdentifier)
        return section.makeCell(for: collectionView, itemIdentifier: itemIdentifier, at: indexPath)
    }

    public func makeSupplementaryView(ofKind elementKind: String, for collectionView: UICollectionView, at indexPath: IndexPath, dataSource: UICollectionViewDiffableDataSource<SectionIdentifier, ItemIdentifier>) -> UICollectionReusableView {
        // # Layout supplement
        for boundarySupplement in boundarySupplements {
            let view = boundarySupplement.makeSupplementaryView(ofKind: elementKind, for: collectionView, value: (), at: indexPath)
            if let view {
                return view
            }
        }
        // # Section supplements
        guard let sectionIdentifier = dataSource.sectionIdentifier(forSectionAtIndex: indexPath.section) else {
            preconditionFailure("Invalid section index")
        }
        let section = self.makeSection(for: sectionIdentifier)
        // Is it a section supplement?
        if let view = section.makeSupplementaryView(forElementKind: elementKind, in: collectionView, indexPath: indexPath, sectionIdentifier: sectionIdentifier) {
            return view
        }
        // Must be item supplement
        guard let itemIdentifier = dataSource.itemIdentifier(for: indexPath) else {
            preconditionFailure("Invalid indexPath")
        }
        if let view = section.makeSupplementaryView(forElementKind: elementKind, in: collectionView, indexPath: indexPath, itemIdentifier: itemIdentifier) {
            return view
        }
        preconditionFailure("Unrecognized supplementary view with elementKind '\(elementKind)'")
    }
}


// MARK: - Initializer

@available(iOS 14, *)
public extension CompositeLayout {

    init(
        indexElementsProvider: DiffableDataSource.IndexElementsProvider? = nil,
        reorderHandlers: DiffableDataSource.ReorderingHandlers? = nil,
        sectionSnapshotHandlers: DiffableDataSource.SectionSnapshotHandlers<ItemIdentifier>? = nil,
        background: LayoutBackground? = nil,
        header: LayoutHeader? = nil,
        footer: LayoutFooter? = nil,
        @ArrayBuilder<CompositeSection<SectionIdentifier, ItemIdentifier>>
        sections: () -> [CompositeSection<SectionIdentifier, ItemIdentifier>]
    ) {
        let boundarySupplements = [
            header?.asBoundarySupplement(),
            footer?.asBoundarySupplement()
        ].compactMap { $0 }

        self = Self(
            behaviors: CollectionViewLayoutBehaviors(
                indexElementsProvider: indexElementsProvider,
                reorderHandlers: reorderHandlers,
                sectionSnapshotHandlers: sectionSnapshotHandlers
            ),
            background: background,
            boundarySupplements: boundarySupplements,
            sections: sections()
        )
    }

    init(
        indexElementsProvider: DiffableDataSource.IndexElementsProvider? = nil,
        reorderHandlers: DiffableDataSource.ReorderingHandlers? = nil,
        sectionSnapshotHandlers: DiffableDataSource.SectionSnapshotHandlers<ItemIdentifier>? = nil,
        background: LayoutBackground? = nil,
        @ArrayBuilder<LayoutBoundarySupplement>
        boundarySupplements: () -> [LayoutBoundarySupplement],
        @ArrayBuilder<CompositeSection<SectionIdentifier, ItemIdentifier>>
        sections: () -> [CompositeSection<SectionIdentifier, ItemIdentifier>]
    ) {
        self = Self(
            behaviors: CollectionViewLayoutBehaviors(
                indexElementsProvider: indexElementsProvider,
                reorderHandlers: reorderHandlers,
                sectionSnapshotHandlers: sectionSnapshotHandlers
            ),
            background: background,
            boundarySupplements: boundarySupplements(),
            sections: sections()
        )
    }
}
