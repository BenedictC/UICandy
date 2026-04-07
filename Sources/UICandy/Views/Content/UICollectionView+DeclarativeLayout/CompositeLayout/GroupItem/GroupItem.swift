import UIKit


@MainActor
public protocol GroupItem<ItemIdentifier> {

    associatedtype ItemIdentifier

    func registerReusableViews(in collectionView: UICollectionView)
    func makeLayoutGroupItem(defaultSize: NSCollectionLayoutSize, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutItem
    func makeCell(for collectionView: UICollectionView, itemIdentifier: ItemIdentifier, at indexPath: IndexPath) -> UICollectionViewCell?
    func makeSupplementaryView(ofKind elementKind: String, for collectionView: UICollectionView, itemIdentifier: ItemIdentifier, at indexPath: IndexPath) -> UICollectionReusableView?
}


public struct SupplementedGroupItem<ItemIdentifier>: GroupItem {

    let groupItem: AnyGroupItem<ItemIdentifier>
    let supplements: [Supplement<ItemIdentifier>]

    public func registerReusableViews(in collectionView: UICollectionView) {
        groupItem.registerReusableViews(in: collectionView)
        for supplement in supplements {
            supplement.registerReusableViews(in: collectionView)
        }
    }

    public func makeLayoutGroupItem(defaultSize: NSCollectionLayoutSize, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutItem {
        let initial = groupItem.makeLayoutGroupItem(defaultSize: defaultSize, environment: environment)
        let supplementaryItems = supplements.map { $0.makeLayoutSupplementaryItem(defaultSize: defaultSize) }
        let revised = NSCollectionLayoutItem(layoutSize: initial.layoutSize, supplementaryItems: supplementaryItems)
        revised.edgeSpacing = initial.edgeSpacing
        revised.contentInsets = initial.contentInsets
        return revised
    }

    public func makeCell(for collectionView: UICollectionView, itemIdentifier: ItemIdentifier, at indexPath: IndexPath) -> UICollectionViewCell? {
        groupItem.makeCell(for: collectionView, itemIdentifier: itemIdentifier, at: indexPath)
    }

    public func makeSupplementaryView(ofKind elementKind: String, for collectionView: UICollectionView, itemIdentifier: ItemIdentifier, at indexPath: IndexPath) -> UICollectionReusableView? {
        for supplement in supplements {
            let view = supplement.makeSupplementaryView(ofKind: elementKind, for: collectionView, itemIdentifier: itemIdentifier, at: indexPath)
            if let view {
                return view
            }
        }
        return nil
    }
}


// MARK: AnyGroupItem

public struct AnyGroupItem<ItemIdentifier>: GroupItem {

    let erased: any GroupItem<ItemIdentifier>

    public func registerReusableViews(in collectionView: UICollectionView) {
        erased.registerReusableViews(in: collectionView)
    }

    public func makeLayoutGroupItem(defaultSize: NSCollectionLayoutSize, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutItem {
        erased.makeLayoutGroupItem(defaultSize: defaultSize, environment: environment)
    }

    public func makeCell(for collectionView: UICollectionView, itemIdentifier: ItemIdentifier, at indexPath: IndexPath) -> UICollectionViewCell? {
        erased.makeCell(for: collectionView, itemIdentifier: itemIdentifier, at: indexPath)
    }

    public func makeSupplementaryView(ofKind elementKind: String, for collectionView: UICollectionView, itemIdentifier: ItemIdentifier, at indexPath: IndexPath) -> UICollectionReusableView? {
        erased.makeSupplementaryView(ofKind: elementKind, for: collectionView, itemIdentifier: itemIdentifier, at: indexPath)
    }
}


public extension GroupItem {

    func eraseToAnyGroupItem() -> AnyGroupItem<ItemIdentifier> {
        AnyGroupItem(erased: self)
    }
}
