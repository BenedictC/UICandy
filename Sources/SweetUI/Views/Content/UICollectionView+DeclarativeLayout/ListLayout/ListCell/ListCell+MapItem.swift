import UIKit


public extension ListCell {
    
    static func mapItem<Value>(
        _ transform: @escaping (ItemIdentifier) -> Value?,
        cell: () -> ListCell<Value>
    ) -> ListCell<ItemIdentifier> {
        let inner = cell()
        return ListCell(
            cellRegistrar: inner.cellRegistrar,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                guard let value = transform(itemIdentifier) else {
                    return nil
                }
                return inner.cellProvider(collectionView, indexPath, value)
            }
        )
    }

    static func mapItem<Value>(
        _ transform: @escaping (ItemIdentifier) -> Value?,
        cell: () -> ListCell<Void>
    ) -> ListCell<ItemIdentifier> {
        let inner = cell()
        return ListCell(
            cellRegistrar: inner.cellRegistrar,
            cellProvider: { collectionView, indexPath, _ in
                return inner.cellProvider(collectionView, indexPath, ())
            }
        )
    }
}
