import UIKit


public extension UICollectionView {

    func dataSource(_ value: UICollectionViewDataSource?) -> Self {
        self.dataSource = value
        return self
    }

    func isPrefetchingEnabled(_ value: Bool) -> Self {
        self.isPrefetchingEnabled = value
        return self
    }

    func prefetchDataSource(_ value: UICollectionViewDataSourcePrefetching?) -> Self {
        self.prefetchDataSource = value
        return self
    }

    func delegate(_ value: UICollectionViewDelegate?) -> Self {
        self.delegate = value
        return self
    }

    func backgroundView(_ value: UIView?) -> Self {
        self.backgroundView = value
        return self
    }

    func collectionViewLayout(_ value: UICollectionViewLayout) -> Self {
        self.collectionViewLayout = value
        return self
    }

    func dragDelegate(_ value: UICollectionViewDragDelegate?) -> Self {
        self.dragDelegate = value
        return self
    }

    func dropDelegate(_ value: UICollectionViewDropDelegate?) -> Self {
        self.dropDelegate = value
        return self
    }

    func reorderingCadence(_ value: UICollectionView.ReorderingCadence) -> Self {
        self.reorderingCadence = value
        return self
    }

    func allowsSelection(_ value: Bool) -> Self {
        self.allowsSelection = value
        return self
    }

    func allowsMultipleSelection(_ value: Bool) -> Self {
        self.allowsMultipleSelection = value
        return self
    }


    func remembersLastFocusedIndexPath(_ value: Bool) -> Self {
        self.remembersLastFocusedIndexPath = value
        return self
    }
}


@available(iOS 14.0, *)
public extension UICollectionView {
    func allowsSelectionDuringEditing(_ value: Bool) -> Self {
        self.allowsSelectionDuringEditing = value
        return self
    }

    func allowsMultipleSelectionDuringEditing(_ value: Bool) -> Self {
        self.allowsMultipleSelectionDuringEditing = value
        return self
    }

    func selectionFollowsFocus(_ value: Bool) -> Self {
        self.selectionFollowsFocus = value
        return self
    }

    func isEditing(_ value: Bool) -> Self {
        self.isEditing = value
        return self
    }
}


@available(iOS 15.0, *)
public extension UICollectionView {
    func allowsFocus(_ value: Bool) -> Self {
        self.allowsFocus = value
        return self
    }

    func allowsFocusDuringEditing(_ value: Bool) -> Self {
        self.allowsFocusDuringEditing = value
        return self
    }

}


@available(iOS 16.0, *)
public extension UICollectionView {
    func selfSizingInvalidation(_ value: UICollectionView.SelfSizingInvalidation) -> Self {
        self.selfSizingInvalidation = value
        return self
    }
}
