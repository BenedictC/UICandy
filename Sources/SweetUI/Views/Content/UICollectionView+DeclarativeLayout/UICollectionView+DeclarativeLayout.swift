import UIKit


@available(iOS 14, *)
public extension UICollectionView {

    convenience init<SectionIdentifier: Hashable, ItemIdentifier: Hashable, Strategy: CollectionViewLayoutStrategy>(
        snapshotCoordinator: CollectionViewSnapshotCoordinator<SectionIdentifier, ItemIdentifier>,
        delegate: UICollectionViewDelegate? = nil,
        layout strategyBuilder: () -> Strategy
    ) where Strategy.SectionIdentifier == SectionIdentifier,
            Strategy.ItemIdentifier == ItemIdentifier
    {
        // Init with placeholder layout
        self.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())

        let strategy = strategyBuilder()

        // Configure dataSource (the dataSource is stored by the snapshotCoordinator)
        let dataSource = snapshotCoordinator.register(
            collectionView: self,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                let dataSource = collectionView.dataSource as! UICollectionViewDiffableDataSource<SectionIdentifier, ItemIdentifier>
                guard let sectionIdentifier = dataSource.sectionIdentifier(forSectionAtIndex: indexPath.section) else {
                    preconditionFailure("Invalid section index")
                }
                let cell = strategy.makeCell(for: collectionView, itemIdentifier: itemIdentifier, in: sectionIdentifier, at: indexPath)
                return cell
            }
        )
        guard let dataSource else {
            log.error("Failed to register collectionView with snapshot coordinator. CollectionView will not function.")
            return
        }
        dataSource.supplementaryViewProvider = { [weak dataSource] collectionView, elementKind, indexPath in
            guard let dataSource else {
                fatalError()
            }
            let view = strategy.makeSupplementaryView(ofKind: elementKind, for: collectionView, at: indexPath, dataSource: dataSource)
            return view
        }
        dataSource.indexElementsProvider = strategy.behaviors.indexElementsProvider
        if let reorderHandlers = strategy.behaviors.reorderHandlers {
            dataSource.reorderingHandlers = reorderHandlers
        }
        if let sectionSnapshotHandlers = strategy.behaviors.sectionSnapshotHandlers {
            dataSource.sectionSnapshotHandlers = sectionSnapshotHandlers
        }

        // Configure and store the final layout
        let layout = strategy.makeLayout(dataSource: dataSource)
        strategy.registerReusableViews(in: self, layout: layout)
        self.collectionViewLayout = layout

        // Configure delegate
        self.delegate = delegate
    }
}
