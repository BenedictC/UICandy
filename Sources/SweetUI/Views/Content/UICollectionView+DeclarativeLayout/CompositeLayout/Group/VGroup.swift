import UIKit


public struct VGroup<ItemIdentifier>: AxisGroup {

    public static var axis: AxisGroupAxis { .vertical }

    public let groupSize: NSCollectionLayoutSize?
    public let items: [AnyGroupItem<ItemIdentifier>]
    public let layoutGroupItemsProvider: LayoutGroupItemsProvider

    public init(
        groupSize: NSCollectionLayoutSize?,
        items: [AnyGroupItem<ItemIdentifier>],
        layoutGroupItemsProvider: @escaping LayoutGroupItemsProvider
    ) {
        self.groupSize = groupSize
        self.items = items
        self.layoutGroupItemsProvider = layoutGroupItemsProvider
    }
}
