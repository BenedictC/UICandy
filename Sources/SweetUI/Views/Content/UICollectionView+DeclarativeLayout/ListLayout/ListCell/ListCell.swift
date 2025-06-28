

public struct ListCell<ItemIdentifier> {

    public typealias CellRegister = (UICollectionView) -> Void
    public typealias CellProvider = (UICollectionView, IndexPath, ItemIdentifier) -> (UICollectionViewCell?)

    let cellRegistrar: CellRegister
    let cellProvider: CellProvider


    public init(
        cellRegistrar: @escaping (UICollectionView) -> Void,
        cellProvider: @escaping CellProvider
    ) {
        self.cellRegistrar = cellRegistrar
        self.cellProvider = cellProvider
    }

    func registerCellClass(in collectionView: UICollectionView) {
        cellRegistrar(collectionView)
    }

    func makeCell(with value: ItemIdentifier, for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell? {
        cellProvider(collectionView, indexPath, value)
    }
}
