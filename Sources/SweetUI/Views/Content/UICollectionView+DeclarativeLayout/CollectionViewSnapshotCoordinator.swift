import UIKit


public enum CollectionViewSnapshotCoordinatorUpdateMode {
    case animated
    case unanimated
    @available(iOS 15, *)
    case reload
}


@available(iOS 14, *)
public final class CollectionViewSnapshotCoordinator<SectionIdentifier: Hashable, ItemIdentifier: Hashable> {

    // MARK: Types

    public typealias DataSource = CollectionViewDiffableDataSource<SectionIdentifier, ItemIdentifier>
    public typealias Snapshot = NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier>
    public typealias SectionSnapshot = NSDiffableDataSourceSectionSnapshot<ItemIdentifier>
    public typealias UpdateAction = (DataSource, CheckedContinuation<Void, Never>) -> Void
    public typealias UpdateMode = CollectionViewSnapshotCoordinatorUpdateMode


    // MARK: Properties

    public private(set) var snapshot: Snapshot
    public private(set) var pendingSnapshot: Snapshot?
    private weak var collectionView: UICollectionView?
    private var dataSource: DataSource?

    // Queue
    private var pendingActions = [UpdateAction]()
    private var currentAction: UpdateAction?


    // MARK: Instance life cycle

    public init(snapshot optionalSnapshot: Snapshot? = nil) {
        self.snapshot = optionalSnapshot ?? Snapshot()
    }


    // MARK: CollectionView registration

    internal func register(collectionView: UICollectionView, cellProvider: @escaping DataSource.CellProvider) -> DataSource? {
        let isAvailableForRegistration = self.collectionView == nil
        guard isAvailableForRegistration else {
            log.error("Attempt to register multiple UICollectionView instances with a CollectionViewSnapshot.")
            return nil
        }

        self.collectionView = collectionView

        let dataSource = DataSource(collectionView: collectionView, cellProvider: cellProvider)
        let initialSnapshot = snapshot
        dataSource.apply(initialSnapshot, animatingDifferences: false)
        self.dataSource = dataSource

        dequeueNextAction()

        return dataSource
    }


    // MARK: Factory

    public func newSnapshot() -> Snapshot {
        Snapshot()
    }


    // MARK: Queue

    private func enqueue(action: @escaping UpdateAction) {
        pendingActions.append(action)
        dequeueNextAction()
    }

    private func dequeueNextAction() {
        guard currentAction == nil,
        let dataSource else {
            return
        }
        guard !pendingActions.isEmpty else {
            return
        }
        let action = pendingActions.removeFirst()
        currentAction = action
        Task { @MainActor in
            await withCheckedContinuation { continuation in
                action(dataSource, continuation)
            }
            currentAction = nil
            dequeueNextAction()
        }
    }
}


// MARK: - Snapshot updating

@available(iOS 14, *)
@MainActor
public extension CollectionViewSnapshotCoordinator {

    func updateSnapshot(
        withMode updateMode: UpdateMode = .animated,
        changes: @escaping (Snapshot) -> Snapshot?,
        completion: ((Bool, Snapshot) -> Void)? = nil
    ) {
        enqueue { dataSource, continuation in
            // Create completion handle
            let dataSourceCompletion = { () -> Void in
                self.pendingSnapshot = nil
                let updatedSnapshot = dataSource.snapshot()
                self.snapshot = updatedSnapshot
                // Send the new value to the complete before updating the subject so that both values will be available to completion()
                completion?(true, updatedSnapshot)
                continuation.resume()
            }

            // Perform changes
            let stale = dataSource.snapshot()
            guard let fresh = changes(stale) else {
                completion?(false, stale)
                continuation.resume()
                return
            }

            // Apply changes
            self.pendingSnapshot = fresh
            switch updateMode {
            case .animated:
                dataSource.apply(fresh, animatingDifferences: true, completion: dataSourceCompletion)

            case .unanimated:
                dataSource.apply(fresh, animatingDifferences: false, completion: dataSourceCompletion)

            case .reload:
                if #available(iOS 15, *) {
                    dataSource.applySnapshotUsingReloadData(fresh, completion: dataSourceCompletion)
                } else {
                    dataSource.apply(fresh, animatingDifferences: false, completion: dataSourceCompletion)
                }
            }
        }
    }

    func updateSnapshot(
        _ snapshot: Snapshot,
        mode: UpdateMode = .animated,
        completion: ((Snapshot) -> Void)? = nil
    ) {
        updateSnapshot(
            withMode: mode,
            changes: { _ in snapshot },
            completion: { completion?($1) }
        )
    }


    // MARK: SectionSnapshot updating

    func updateSectionSnapshot(
        animatingDifferences animated: Bool = true,
        changes: @escaping (Snapshot) -> (SectionIdentifier, SectionSnapshot)?,
        completion: ((Bool, Snapshot) -> Void)? = nil
    ) {
        enqueue { dataSource, continuation in
            // Create completion handle
            let dataSourceCompletion = { () -> Void in
                let updatedSnapshot = dataSource.snapshot()
                self.snapshot = updatedSnapshot
                // Send the new value to the complete before updating the subject so that both values will be available to completion()
                completion?(true, updatedSnapshot)
                continuation.resume()
            }

            // Perform changes
            let stale = dataSource.snapshot()
            guard let (sectionIdentifier, sectionSnapshot) = changes(stale) else {
                completion?(false, stale)
                continuation.resume()
                return
            }

            // Apply changes
            dataSource.apply(sectionSnapshot, to: sectionIdentifier, animatingDifferences: animated, completion: dataSourceCompletion)
        }
    }
}


// MARK: - Async variants

@available(iOS 14, *)
@MainActor
public extension CollectionViewSnapshotCoordinator {

    @discardableResult
    func updateSnapshot(
        withMode updateMode: UpdateMode = .animated,
        changes: @escaping (Snapshot) -> Snapshot?
    ) async -> (Bool, Snapshot) {
        await withCheckedContinuation { continuation in
            self.updateSnapshot(
                withMode: updateMode,
                changes: changes,
                completion: { continuation.resume(returning: ($0, $1)) }
            )
        }
    }

    func updateSnapshot(_ snapshot: Snapshot, mode: UpdateMode = .animated) async {
        await withCheckedContinuation { continuation in
            self.updateSnapshot(
                withMode: mode,
                changes: { _ in snapshot },
                completion: { _, _ in continuation.resume() }
            )
        }
    }

    @discardableResult
    func updateSectionSnapshot(
        animatingDifferences animated: Bool = true,
        changes: @escaping (Snapshot) -> (SectionIdentifier, SectionSnapshot)?
    ) async -> (Bool, Snapshot) {
        await withCheckedContinuation { continuation in
            updateSectionSnapshot(
                animatingDifferences: animated,
                changes: changes,
                completion: { continuation.resume(returning: ($0, $1)) }
            )
        }
    }
}


// MARK: - NSDiffableDataSourceSnapshot

public extension NSDiffableDataSourceSnapshot {

    mutating func reset() {
        self = Self()
    }

    func deletingAllItems() -> Self {
        Self()
    }

    @available(iOS 14, *)
    func newSectionSnapshot() -> NSDiffableDataSourceSectionSnapshot<ItemIdentifierType> {
        NSDiffableDataSourceSectionSnapshot<ItemIdentifierType>()
    }
}
