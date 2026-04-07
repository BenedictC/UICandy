import UIKit


public protocol Decoration {

    var elementKind: String { get }

    func registerDecorationView(in layout: UICollectionViewLayout)
    func makeLayoutDecorationItem() -> NSCollectionLayoutDecorationItem
}
