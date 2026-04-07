// MARK: - ListSection

@MainActor
public struct ListSection<SectionIdentifier: Hashable, ItemIdentifier: Hashable, HeaderType> {

    private let predicate: (SectionIdentifier) -> Bool
    private let header: AnyListSection<SectionIdentifier, ItemIdentifier>.HeaderKind
    private let cells: [ListCell<ItemIdentifier>]
    private let footer: SectionFooter<SectionIdentifier>?

    init(
        predicate: @escaping (SectionIdentifier) -> Bool,
        header: AnyListSection<SectionIdentifier, ItemIdentifier>.HeaderKind,
        cells: [ListCell<ItemIdentifier>],
        footer: SectionFooter<SectionIdentifier>?
    ) {
        self.predicate = predicate
        self.header = header
        self.cells = cells
        self.footer = footer
    }

    func eraseToAnyListSection() -> AnyListSection<SectionIdentifier, ItemIdentifier> {
        AnyListSection(predicate: predicate, header: header, cells: cells, footer: footer)
    }
}
