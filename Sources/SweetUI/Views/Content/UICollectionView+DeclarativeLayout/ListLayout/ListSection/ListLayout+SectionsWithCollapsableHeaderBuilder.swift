import UIKit


// MARK: - Layout

@available(iOS 15, *)
public extension ListLayout {

    typealias ListSectionWithCollapsableHeader = ListSection<SectionIdentifier, ItemIdentifier, ItemIdentifier>

    init(
        appearance: UICollectionLayoutListConfiguration.Appearance,
        configuration: LayoutConfiguration = LayoutConfiguration(builder: { _ in }),
        indexElementsProvider: DiffableDataSource.IndexElementsProvider? = nil,
        reorderHandlers: DiffableDataSource.ReorderingHandlers? = nil,
        sectionSnapshotHandlers: DiffableDataSource.SectionSnapshotHandlers<ItemIdentifier>? = nil,
        background: LayoutBackground? = nil,
        header: LayoutHeader? = nil,
        footer: LayoutFooter? = nil,
        @ArrayBuilder<ListSectionWithCollapsableHeader>
        sectionsWithCollapsableHeader sections: () -> [ListSectionWithCollapsableHeader]
    ) {
        let boundarySupplements = [
            header?.asBoundarySupplement(),
            footer?.asBoundarySupplement()
        ].compactMap { $0 }
        let components = ListLayoutComponents(
            configuration: configuration,
            background: background,
            boundarySupplements: boundarySupplements,
            sections: sections().map { $0.eraseToAnyListSection() }
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
        footer: LayoutFooter? = nil,
        @ArrayBuilder<ListSectionWithCollapsableHeader>
        sectionsWithCollapsableHeader sections: () -> [ListSectionWithCollapsableHeader]
    ) {
        let components = ListLayoutComponents(
            configuration: configuration,
            background: background,
            boundarySupplements: boundarySupplements(),
            sections: sections().map { $0.eraseToAnyListSection() }
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
public extension ListSection where HeaderType == ItemIdentifier {

    init(
        predicate: @escaping ((SectionIdentifier) -> Bool) = { _ in true },
        header: ListCell<ItemIdentifier>,
        footer: SectionFooter<SectionIdentifier>? = nil,
        cells: [ListCell<ItemIdentifier>]
    ) {
        self = Self(
            predicate: predicate,
            header: .collapsable(header),
            cells: cells,
            footer: footer
        )
    }

    init(
        identifier: SectionIdentifier,
        header: ListCell<ItemIdentifier>,
        footer: SectionFooter<SectionIdentifier>? = nil,
        cells: [ListCell<ItemIdentifier>]
    ) {
        self = Self(
            predicate: { $0 == identifier },
            header: .collapsable(header),
            cells: cells,
            footer: footer
        )
    }
}


@available(iOS 15, *)
public extension ListSection where HeaderType == ItemIdentifier {

    init(
        predicate: @escaping ((SectionIdentifier) -> Bool) = { _ in true },
        header: ListCell<ItemIdentifier>,
        footer: () -> SectionFooter<SectionIdentifier>,
        @ArrayBuilder<ListCell<ItemIdentifier>>
        cells: () -> [ListCell<ItemIdentifier>]
    ) {
        self = Self(
            predicate: predicate,
            header: .collapsable(header),
            cells: cells(),
            footer: footer()
        )
    }

    init(
        identifier: SectionIdentifier,
        header: ListCell<ItemIdentifier>,
        footer: () -> SectionFooter<SectionIdentifier>,
        @ArrayBuilder<ListCell<ItemIdentifier>>
        cells: () -> [ListCell<ItemIdentifier>]
    ) {
        self = Self(
            predicate: { $0 == identifier },
            header: .collapsable(header),
            cells: cells(),
            footer: footer()
        )
    }

    init(
        predicate: @escaping ((SectionIdentifier) -> Bool) = { _ in true },
        header: ListCell<ItemIdentifier>,
        @ArrayBuilder<ListCell<ItemIdentifier>>
        cells: () -> [ListCell<ItemIdentifier>]
    ) {
        self = Self(
            predicate: predicate,
            header: .collapsable(header),
            cells: cells(),
            footer: nil
        )
    }

    init(
        identifier: SectionIdentifier,
        header: ListCell<ItemIdentifier>,
        @ArrayBuilder<ListCell<ItemIdentifier>>
        cells: () -> [ListCell<ItemIdentifier>]
    ) {
        self = Self(
            predicate: { $0 == identifier },
            header: .collapsable(header),
            cells: cells(),
            footer: nil
        )
    }
}
