import Combine


// MARK: - Static

public extension SectionHeader {

    init(
        contentBuilder: @escaping (UICollectionViewCell, any CurrentValuePublisher<SectionIdentifier, Never>) -> UIView
    ) {
        typealias CellType = ValuePublishingCell<SectionIdentifier>
        let elementKind = Self.elementKind
        let reuseIdentifier = UniqueIdentifier("\(Self.self) reuseIdentifier").value

        self.init(
            supplementRegistrar: { collectionView in
                collectionView.register(CellType.self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: reuseIdentifier)
            },
            supplementProvider: { elementKind, collectionView, indexPath, sectionIdentifier in
                let cell = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: reuseIdentifier, for: indexPath) as! CellType
                cell.initialize(bodyProvider: contentBuilder)
                cell.configure(withValue: sectionIdentifier)
                return cell
            }
        )
    }
}
