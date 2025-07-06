import UIKit


public extension Group {

    func supplements(
        @ArrayBuilder<Supplement<ItemIdentifier>>
        _ supplementsBuilder: () -> [Supplement<ItemIdentifier>]
    ) -> SupplementedGroup<ItemIdentifier> {
        let supplements = supplementsBuilder()
        return SupplementedGroup<ItemIdentifier>(
            group: self,
            supplements: supplements
        )
    }
}


// MARK: - SupplementedGroup

public struct SupplementedGroup<ItemIdentifier>: Group {

    let group: any Group<ItemIdentifier>
    let supplements: [Supplement<ItemIdentifier>]

    init(group: some Group<ItemIdentifier>, supplements: [Supplement<ItemIdentifier>]) {
        self.group = group
        self.supplements = supplements
    }


    // MARK: GroupItem

    public func registerReusableViews(in collectionView: UICollectionView) {
        group.registerReusableViews(in: collectionView)
        for supplement in supplements {
            supplement.registerReusableViews(in: collectionView)
        }
    }

    public func makeLayoutGroupItem(defaultSize: NSCollectionLayoutSize, environment: any NSCollectionLayoutEnvironment) -> NSCollectionLayoutItem {
        makeLayoutGroup(environment: environment)
    }

    public func makeCell(for collectionView: UICollectionView, itemIdentifier: ItemIdentifier, at indexPath: IndexPath) -> UICollectionViewCell? {
        group.makeCell(for: collectionView, itemIdentifier: itemIdentifier, at: indexPath)
    }

    public func makeSupplementaryView(ofKind elementKind: String, for collectionView: UICollectionView, itemIdentifier: ItemIdentifier, at indexPath: IndexPath) -> UICollectionReusableView? {
        for supplement in supplements {
            let view = supplement.makeSupplementaryView(ofKind: elementKind, for: collectionView, itemIdentifier: itemIdentifier, at: indexPath)
            if let view {
                return view
            }
        }
        return group.makeSupplementaryView(ofKind: elementKind, for: collectionView, itemIdentifier: itemIdentifier, at: indexPath)
    }


    // MARK: Group

    public func makeLayoutGroup(environment: any NSCollectionLayoutEnvironment) -> NSCollectionLayoutGroup {
        let layout = group.makeLayoutGroup(environment: environment)
        let supplementaryItems = supplements.map { $0.makeLayoutSupplementaryItem(defaultSize: layout.layoutSize) }
        layout.supplementaryItems = supplementaryItems
        return layout
    }

    public func makeCell(for collectionView: UICollectionView, itemIdentifier: ItemIdentifier, at indexPath: IndexPath) -> UICollectionViewCell {
        group.makeCell(for: collectionView, itemIdentifier: itemIdentifier, at: indexPath)
    }

    public func makeSupplementaryView(ofKind elementKind: String, for collectionView: UICollectionView, itemIdentifier: ItemIdentifier, at indexPath: IndexPath) -> UICollectionReusableView {
        let view: UICollectionReusableView? = makeSupplementaryView(ofKind: elementKind, for: collectionView, itemIdentifier: itemIdentifier, at: indexPath)
        guard let view else {
            preconditionFailure()
        }
        return view
    }
}
