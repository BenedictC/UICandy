import UIKit


// MARK: - Layout

@available(iOS 15, *)
public extension ListLayout {

    typealias ListSectionWithStandardHeader = ListSection<SectionIdentifier, ItemIdentifier, SectionIdentifier>

    init(
        appearance: UICollectionLayoutListConfiguration.Appearance,
        configuration: LayoutConfiguration = LayoutConfiguration(builder: { _ in }),
        indexElementsProvider: DiffableDataSource.IndexElementsProvider? = nil,
        reorderHandlers: DiffableDataSource.ReorderingHandlers? = nil,
        sectionSnapshotHandlers: DiffableDataSource.SectionSnapshotHandlers<ItemIdentifier>? = nil,
        background: LayoutBackground? = nil,
        header: LayoutHeader? = nil,
        footer: LayoutFooter? = nil,
        @ArrayBuilder<ListSectionWithStandardHeader>
        sectionsWithStandardHeader sections: () -> [ListSectionWithStandardHeader]
    ) {
        let boundarySupplements = [
            header?.asBoundarySupplement(),
            footer?.asBoundarySupplement()
        ].compactMap { $0 }

        let anySections = sections().map { $0.eraseToAnyListSection() }
        let components = ListLayoutComponents<SectionIdentifier, ItemIdentifier>(
            configuration: configuration,
            background: background,
            boundarySupplements: boundarySupplements,
            sections: anySections
        )
        let behaviors = CollectionViewLayoutBehaviors(
            indexElementsProvider: indexElementsProvider,
            reorderHandlers: reorderHandlers,
            sectionSnapshotHandlers: sectionSnapshotHandlers
        )

        self.init(appearance: appearance, components: components, behaviors: behaviors)
    }

    init(
        appearance: UICollectionLayoutListConfiguration.Appearance,
        configuration: LayoutConfiguration = LayoutConfiguration(builder: { _ in }),
        indexElementsProvider: DiffableDataSource.IndexElementsProvider? = nil,
        reorderHandlers: DiffableDataSource.ReorderingHandlers? = nil,
        sectionSnapshotHandlers: DiffableDataSource.SectionSnapshotHandlers<ItemIdentifier>? = nil,
        background: LayoutBackground? = nil,
        @ArrayBuilder<LayoutBoundarySupplement>
        boundarySupplements: () -> [LayoutBoundarySupplement],
        @ArrayBuilder<ListSectionWithStandardHeader>
        sectionsWithStandardHeader sections: () -> [ListSectionWithStandardHeader]
    ) {
        let anySections = sections().map { $0.eraseToAnyListSection() }
        let components = ListLayoutComponents<SectionIdentifier, ItemIdentifier>(
            configuration: configuration,
            background: background,
            boundarySupplements: boundarySupplements(),
            sections: anySections
        )
        let behaviors = CollectionViewLayoutBehaviors(
            indexElementsProvider: indexElementsProvider,
            reorderHandlers: reorderHandlers,
            sectionSnapshotHandlers: sectionSnapshotHandlers
        )

        self.init(appearance: appearance, components: components, behaviors: behaviors)
    }
}


// MARK: - ListSection

@available(iOS 15, *)
public extension ListSection where HeaderType == SectionIdentifier {

    init(
        predicate: @escaping ((SectionIdentifier) -> Bool) = { _ in true },
        header: SectionHeader<SectionIdentifier>,
        footer: SectionFooter<SectionIdentifier>? = nil,
        cells: [ListCell<ItemIdentifier>]
    ) {
        self = Self(
            predicate: predicate,
            header: .standard(header),
            cells: cells,
            footer: footer
        )
    }

    init(
        identifier: SectionIdentifier,
        header: SectionHeader<SectionIdentifier>,
        footer: SectionFooter<SectionIdentifier>? = nil,
        cells: [ListCell<ItemIdentifier>]
    ) {
        self = Self(
            predicate: { $0 == identifier },
            header: .standard(header),
            cells: cells,
            footer: footer
        )
    }
}


@available(iOS 15, *)
public extension ListSection where HeaderType == SectionIdentifier {

    init(
        predicate: @escaping ((SectionIdentifier) -> Bool) = { _ in true },
        header: SectionHeader<SectionIdentifier>,
        footer: SectionFooter<SectionIdentifier>,
        @ArrayBuilder<ListCell<ItemIdentifier>>
        cells: () -> [ListCell<ItemIdentifier>]
    ) {
        self = Self(
            predicate: predicate,
            header: .standard(header),
            cells: cells(),
            footer: footer
        )
    }

    init(
        identifier: SectionIdentifier,
        header: SectionHeader<SectionIdentifier>,
        footer: SectionFooter<SectionIdentifier>,
        @ArrayBuilder<ListCell<ItemIdentifier>>
        cells: () -> [ListCell<ItemIdentifier>]
    ) {
        self = Self(
            predicate: { $0 == identifier },
            header: .standard(header),
            cells: cells(),
            footer: footer
        )
    }

    init(
        predicate: @escaping ((SectionIdentifier) -> Bool) = { _ in true },
        header: SectionHeader<SectionIdentifier>,
        @ArrayBuilder<ListCell<ItemIdentifier>>
        cells: () -> [ListCell<ItemIdentifier>]
    ) {
        self = Self(
            predicate: predicate,
            header: .standard(header),
            cells: cells(),
            footer: nil
        )
    }

    init(
        identifier: SectionIdentifier,
        header: SectionHeader<SectionIdentifier>,
        @ArrayBuilder<ListCell<ItemIdentifier>>
        cells: () -> [ListCell<ItemIdentifier>]
    ) {
        self = Self(
            predicate: { $0 == identifier },
            header: .standard(header),
            cells: cells(),
            footer: nil
        )
    }
}
