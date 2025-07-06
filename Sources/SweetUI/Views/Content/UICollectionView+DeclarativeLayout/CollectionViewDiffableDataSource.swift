import UIKit


public typealias CollectionViewDiffableDataSourceIndexElement = (title: String, indexPath: IndexPath)


public final class CollectionViewDiffableDataSource<SectionIdentifierType: Hashable, ItemIdentifierType: Hashable>: UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType> {

    // MARK: Types

    public typealias IndexElement = CollectionViewDiffableDataSourceIndexElement
    public typealias IndexElementsProvider = (NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>) -> [IndexElement]


    // MARK: Properties

    public var indexElementsProvider: IndexElementsProvider? {
        didSet { collectionView?.reloadData() }
    }

    private weak var collectionView: UICollectionView?
    private var cachedIndexElements: [IndexElement]?


    // MARK: Instance life cycle

    override internal init(collectionView: UICollectionView, cellProvider: @escaping CellProvider) {
        self.collectionView = collectionView
        super.init(collectionView: collectionView, cellProvider: cellProvider)
    }


    // MARK: UICollectionViewDataSource overrides

    @MainActor
    public override func indexTitles(for collectionView: UICollectionView) -> [String]? {
        guard let indexElementsProvider else {
            cachedIndexElements = nil
            return nil
        }
        let snapshot = self.snapshot()
        let indexElements = indexElementsProvider(snapshot)
        self.cachedIndexElements = indexElements
        return indexElements.map { $0.title }
    }

    public override func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath {
        guard let cachedIndexElements else {
            // This shouldn't happen, but if it does go to the first item in the layout
            return IndexPath(item: 0, section: 0)
        }
        return cachedIndexElements[index].indexPath
    }
}


// MARK: - Backport for iOS 14

internal extension UICollectionViewDiffableDataSource {

    func sectionIdentifier(forSectionAtIndex sectionIndex: Int) -> SectionIdentifierType? {
        let snapshot = self.snapshot()
        guard sectionIndex < snapshot.sectionIdentifiers.count else {
            return nil
        }
        return snapshot.sectionIdentifiers[sectionIndex]
    }
}
