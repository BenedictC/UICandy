

public extension CompositeCell {

    init<CellType: UICollectionViewCell & ItemRepresentable>(
        cellType: CellType.Type = CellType.self
    ) where CellType.Item == ItemIdentifier {
        let reuseIdentifier = UniqueIdentifier("\(Self.self)").value
        self = CompositeCell(
            cellRegistrar: { collectionView in
                collectionView.register(CellType.self, forCellWithReuseIdentifier: reuseIdentifier)
            },
            cellProvider: { collectionView, indexPath, value in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CellType
                cell.item = value
                return cell
            }
        )
    }
}


@available(iOS 15, *)
public extension CompositeCell {

    init<CellType: UICollectionViewCell>(
        cellType: CellType.Type = CellType.self,
        configuration: @escaping (CellType, UICellConfigurationState, ItemIdentifier) -> Void
    ) {
        let reuseIdentifier = UniqueIdentifier("\(Self.self)").value
        self = CompositeCell(
            cellRegistrar: { collectionView in
                collectionView.register(CellType.self, forCellWithReuseIdentifier: reuseIdentifier)
            },
            cellProvider: { collectionView, indexPath, value in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CellType
                cell.configurationUpdateHandler = { cell, state in
                    guard let cell = cell as? CellType else {
                        return
                    }
                    configuration(cell, state, value)
                }
                return cell
            }
        )
    }
}
