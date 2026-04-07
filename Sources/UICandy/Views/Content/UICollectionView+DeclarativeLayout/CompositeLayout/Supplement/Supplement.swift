import UIKit


@MainActor
public struct Supplement<Value> {

    // MARK: Types

    public typealias SupplementRegister = (UICollectionView) -> Void
    public typealias LayoutSupplementaryItemProvider = (NSCollectionLayoutSize) -> NSCollectionLayoutSupplementaryItem
    public typealias SupplementProvider = (String, UICollectionView, IndexPath, Value) -> UICollectionReusableView?


    // MARK: Properties

    let elementKind: String
    private let supplementRegistrar: SupplementRegister
    private let layoutSupplementaryItemProvider: LayoutSupplementaryItemProvider
    private let supplementProvider: SupplementProvider


    // MARK: Instance life cycle

    init(
        elementKind: String,
        supplementRegistrar: @escaping SupplementRegister,
        layoutSupplementaryItemProvider: @escaping LayoutSupplementaryItemProvider,
        supplementProvider: @escaping SupplementProvider
    ) {
        self.elementKind = elementKind
        self.supplementRegistrar = supplementRegistrar
        self.layoutSupplementaryItemProvider = layoutSupplementaryItemProvider
        self.supplementProvider = supplementProvider
    }


    // MARK: View registration

    func registerReusableViews(in collectionView: UICollectionView) {
        supplementRegistrar(collectionView)
    }


    // MARK: Layout creation

    func makeLayoutSupplementaryItem(defaultSize: NSCollectionLayoutSize) -> NSCollectionLayoutSupplementaryItem {
        layoutSupplementaryItemProvider(defaultSize)
    }


    // MARK: View creation

    func makeSupplementaryView(ofKind elementKind: String, for collectionView: UICollectionView, itemIdentifier: Value, at indexPath: IndexPath) -> UICollectionReusableView? {
        guard elementKind == self.elementKind else { return nil }
        return supplementProvider(elementKind, collectionView, indexPath, itemIdentifier)
    }
}
