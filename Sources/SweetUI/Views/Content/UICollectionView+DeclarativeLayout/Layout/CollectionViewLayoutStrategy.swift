import UIKit


// MARK: - CollectionViewLayoutStrategy

@available(iOS 14, *)
public protocol CollectionViewLayoutStrategy<SectionIdentifier, ItemIdentifier> {

    associatedtype SectionIdentifier: Hashable
    associatedtype ItemIdentifier: Hashable
    typealias DiffableDataSource = CollectionViewDiffableDataSource<SectionIdentifier, ItemIdentifier>

    var behaviors: CollectionViewLayoutBehaviors<SectionIdentifier, ItemIdentifier> { get }

    func registerReusableViews(in collectionView: UICollectionView, layout: UICollectionViewLayout)
    func makeLayout(dataSource: UICollectionViewDiffableDataSource<SectionIdentifier, ItemIdentifier>) -> UICollectionViewLayout
    func makeCell(for collectionView: UICollectionView, itemIdentifier: ItemIdentifier, in sectionIdentifier: SectionIdentifier, at indexPath: IndexPath) -> UICollectionViewCell
    func makeSupplementaryView(ofKind elementKind: String, for collectionView: UICollectionView, at indexPath: IndexPath, dataSource: UICollectionViewDiffableDataSource<SectionIdentifier, ItemIdentifier>) -> UICollectionReusableView
}


// MARK: - CollectionViewLayoutBehaviors

@available(iOS 14, *)
public struct CollectionViewLayoutBehaviors<SectionIdentifier: Hashable, ItemIdentifier: Hashable> {

    public typealias Snapshot = NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier>
    public typealias DiffableDataSource = CollectionViewDiffableDataSource<SectionIdentifier, ItemIdentifier>
    public typealias IndexElement = DiffableDataSource.IndexElement
    public typealias IndexElementsProvider = DiffableDataSource.IndexElementsProvider

    public let indexElementsProvider: IndexElementsProvider?
    public let reorderHandlers: DiffableDataSource.ReorderingHandlers?
    public let sectionSnapshotHandlers: DiffableDataSource.SectionSnapshotHandlers<ItemIdentifier>?

    public init(
        indexElementsProvider: IndexElementsProvider?,
        reorderHandlers: DiffableDataSource.ReorderingHandlers?,
        sectionSnapshotHandlers: DiffableDataSource.SectionSnapshotHandlers<ItemIdentifier>?
    ) {
        self.indexElementsProvider = indexElementsProvider
        self.reorderHandlers = reorderHandlers
        self.sectionSnapshotHandlers = sectionSnapshotHandlers
    }
}
