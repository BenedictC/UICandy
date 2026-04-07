import UIKit


// MARK: - Core types

@MainActor
public protocol Group<ItemIdentifier>: GroupItem {

    associatedtype ItemIdentifier

    func registerReusableViews(in collectionView: UICollectionView)
    func makeLayoutGroup(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutGroup
    func makeCell(for collectionView: UICollectionView, itemIdentifier: ItemIdentifier, at indexPath: IndexPath) -> UICollectionViewCell
    func makeSupplementaryView(ofKind elementKind: String, for collectionView: UICollectionView, itemIdentifier: ItemIdentifier, at indexPath: IndexPath) -> UICollectionReusableView
}


extension Group {

    static var defaultGroupSize: NSCollectionLayoutSize {
        NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(100)
        )
    }
}


// MARK: - AnyGroup

public struct AnyGroup<ItemIdentifier>: Group {

    let erased: any Group<ItemIdentifier>
}


// MARK: Group

public extension AnyGroup {

    func registerReusableViews(in collectionView: UICollectionView) {
        erased.registerReusableViews(in: collectionView)
    }

    func makeLayoutGroup(environment: any NSCollectionLayoutEnvironment) -> NSCollectionLayoutGroup {
        erased.makeLayoutGroup(environment: environment)
    }

    func makeCell(for collectionView: UICollectionView, itemIdentifier: ItemIdentifier, at indexPath: IndexPath) -> UICollectionViewCell {
        erased.makeCell(for: collectionView, itemIdentifier: itemIdentifier, at: indexPath)
    }

    func makeSupplementaryView(ofKind elementKind: String, for collectionView: UICollectionView, itemIdentifier: ItemIdentifier, at indexPath: IndexPath) -> UICollectionReusableView {
        erased.makeSupplementaryView(ofKind: elementKind, for: collectionView, itemIdentifier: itemIdentifier, at: indexPath)
    }
}


// MARK: - GroupItem

public extension AnyGroup {

    func makeLayoutGroupItem(defaultSize: NSCollectionLayoutSize, environment: any NSCollectionLayoutEnvironment) -> NSCollectionLayoutItem {
        erased.makeLayoutGroupItem(defaultSize: defaultSize, environment: environment)
    }

    func makeCell(for collectionView: UICollectionView, itemIdentifier: ItemIdentifier, at indexPath: IndexPath) -> UICollectionViewCell? {
        erased.makeCell(for: collectionView, itemIdentifier: itemIdentifier, at: indexPath)
    }

    func makeSupplementaryView(ofKind elementKind: String, for collectionView: UICollectionView, itemIdentifier: ItemIdentifier, at indexPath: IndexPath) -> UICollectionReusableView? {
        erased.makeSupplementaryView(ofKind: elementKind, for: collectionView, itemIdentifier: itemIdentifier, at: indexPath)
    }
}


extension Group {

    func eraseToAnyGroup() -> AnyGroup<ItemIdentifier> {
        AnyGroup(erased: self)
    }
}
