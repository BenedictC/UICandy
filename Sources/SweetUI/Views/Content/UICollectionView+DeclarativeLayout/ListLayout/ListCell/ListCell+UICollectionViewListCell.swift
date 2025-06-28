import UIKit


@available(iOS 15, *)
public extension ListCell {

    init(configuration: @escaping (UICollectionViewListCell, UICellConfigurationState, ItemIdentifier) -> Void) {
        let reuseIdentifier = UniqueIdentifier("\(Self.self)").value
        
        self = ListCell(
            cellRegistrar: { collectionView in
                collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: reuseIdentifier)
            },
            cellProvider: { collectionView, indexPath, value in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UICollectionViewListCell
                cell.configurationUpdateHandler = { cell, state in
                    guard let cell = cell as? UICollectionViewListCell else {
                        return
                    }
                    configuration(cell, state, value)
                }
                return cell
            }
        )
    }
}
