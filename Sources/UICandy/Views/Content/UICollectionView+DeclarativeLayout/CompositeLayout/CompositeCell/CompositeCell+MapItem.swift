
public extension CompositeCell {

    static func mapItem<Value>(
        _ transform: @escaping (ItemIdentifier) -> Value?,
        cell: () -> CompositeCell<Value>
    ) -> CompositeCell<ItemIdentifier> {
        let inner = cell()
        return CompositeCell(
            cellRegistrar: inner.cellRegistrar,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                guard let value = transform(itemIdentifier) else {
                    return nil
                }
                return inner.cellProvider(collectionView, indexPath, value)
            },
            layoutGroupItemProvider: inner.layoutGroupItemProvider
        )
    }

    static func mapItem<Value>(
        _ transform: @escaping (ItemIdentifier) -> Value?,
        cell: () -> CompositeCell<Void>
    ) -> CompositeCell<ItemIdentifier> {
        let inner = cell()
        return CompositeCell(
            cellRegistrar: inner.cellRegistrar,
            cellProvider: { collectionView, indexPath, _ in
                return inner.cellProvider(collectionView, indexPath, ())
            }
        )
    }
}
