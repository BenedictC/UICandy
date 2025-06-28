import UIKit


@available(iOS 15, *)
public extension CompositeCell {

    init(
        predicate: @escaping Predicate = { _, _ in true },
        size: NSCollectionLayoutSize? = nil,
        edgeSpacing: NSCollectionLayoutEdgeSpacing? = nil,
        contentInsets: NSDirectionalEdgeInsets? = nil,
        configuration: @escaping (UICollectionViewListCell, UICellConfigurationState, ItemIdentifier) -> Void
    ) {
        let reuseIdentifier = UniqueIdentifier("\(Self.self)").value
        self = CompositeCell(
            cellRegistrar: { collectionView in
                collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: reuseIdentifier)
            },
            cellProvider: { collectionView, indexPath, value in
                guard predicate(indexPath, value) else { return nil }
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UICollectionViewListCell
                cell.configurationUpdateHandler = { cell, state in
                    guard let cell = cell as? UICollectionViewListCell else {
                        return
                    }
                    configuration(cell, state, value)
                }
                return cell
            },
            layoutGroupItemProvider: Self.makeLayoutGroupItemProvider(size: size, edgeSpacing: edgeSpacing, contentInsets: contentInsets)
        )
    }
}
