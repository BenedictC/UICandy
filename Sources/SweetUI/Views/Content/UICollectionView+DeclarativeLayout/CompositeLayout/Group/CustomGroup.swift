import UIKit


public struct CustomGroup<ItemIdentifier>: Group {

    let size: NSCollectionLayoutSize?
    let groupItems: [AnyGroupItem<ItemIdentifier>]
    let layoutItemsProvider: NSCollectionLayoutGroupCustomItemProvider


    public init(
        size: NSCollectionLayoutSize? = nil,
        layoutItemsProvider: @escaping NSCollectionLayoutGroupCustomItemProvider,
        @GroupItemsBuilder<AnyGroupItem<ItemIdentifier>>
        items: () -> [AnyGroupItem<ItemIdentifier>]
    ) {
        self.size = size
        self.layoutItemsProvider = layoutItemsProvider
        self.groupItems = items()
    }


    // MARK: Group

    public func registerReusableViews(in collectionView: UICollectionView) {
        for cell in groupItems {
            cell.registerReusableViews(in: collectionView)
        }
    }

    public func makeLayoutGroup(environment: any NSCollectionLayoutEnvironment) -> NSCollectionLayoutGroup {
        let size = self.size ?? Self.defaultGroupSize
        return NSCollectionLayoutGroup.custom(layoutSize: size, itemProvider: layoutItemsProvider)
    }

    public func makeCell(for collectionView: UICollectionView, itemIdentifier: ItemIdentifier, at indexPath: IndexPath) -> UICollectionViewCell {
        fatalError()
    }

    public func makeSupplementaryView(ofKind elementKind: String, for collectionView: UICollectionView, itemIdentifier: ItemIdentifier, at indexPath: IndexPath) -> UICollectionReusableView {
        fatalError()
    }


    // MARK: GroupItem

    public func makeLayoutGroupItem(defaultSize: NSCollectionLayoutSize, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutItem {
        fatalError()
    }

    public func makeCell(for collectionView: UICollectionView, itemIdentifier: ItemIdentifier, at indexPath: IndexPath) -> UICollectionViewCell? {
        fatalError()
    }

    public func makeSupplementaryView(ofKind elementKind: String, for collectionView: UICollectionView, itemIdentifier: ItemIdentifier, at indexPath: IndexPath) -> UICollectionReusableView? {
        fatalError()
    }
}
