import Combine


// MARK: - Published Value

public extension ListCell {

    static func withContent(
        contentBuilder: @escaping (UICollectionViewCell, any CurrentValuePublisher<ItemIdentifier, Never>) -> UIView
    ) -> ListCell<ItemIdentifier> {
        typealias CellType = ValuePublishingCell<ItemIdentifier>
        let reuseIdentifier = UniqueIdentifier("\(CellType.self)").value
        return ListCell(
            cellRegistrar: { collectionView in
                collectionView.register(CellType.self, forCellWithReuseIdentifier: reuseIdentifier)
            },
            cellProvider: { collectionView, indexPath, value in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CellType
                cell.initialize(bodyProvider: contentBuilder)
                cell.configure(withValue: value)
                return cell
            }
        )
    }
}
