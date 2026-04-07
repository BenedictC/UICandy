import UIKit


public protocol ReuseIdentifiable {

    static var reuseIdentifier: String { get }
}


public extension ReuseIdentifiable {

    static var reuseIdentifier: String { String(describing: self) }
}


// MARK: - UICollectionView additions

public extension UICollectionView {

    func register<T: UICollectionViewCell & ReuseIdentifiable>(_ cellType: T.Type) {
        register(cellType, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell & ReuseIdentifiable>(ofType cellType: T.Type, for indexPath: IndexPath) -> T {
        let anyCell = dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath)
        guard let cell = anyCell as? T else {
            preconditionFailure("Dequeued cell of unexpected type for reuseIdentifier '\(cellType.reuseIdentifier)'. Expected: '\(cellType)'; actual: '\(type(of: anyCell))'")
        }
        return cell
    }
}
