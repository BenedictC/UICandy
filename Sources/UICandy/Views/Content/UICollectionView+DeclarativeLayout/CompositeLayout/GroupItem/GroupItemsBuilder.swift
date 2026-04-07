
@MainActor
@resultBuilder
public struct GroupItemsBuilder<ItemIdentifier> {

    public static func buildBlock(
        _ item0: some GroupItem<ItemIdentifier>
    ) -> [AnyGroupItem<ItemIdentifier>] {
        [item0.eraseToAnyGroupItem()]
    }

    public static func buildBlock(
        _ item0: some GroupItem<ItemIdentifier>,
        _ item1: some GroupItem<ItemIdentifier>
    ) -> [AnyGroupItem<ItemIdentifier>] {
        [
            item0.eraseToAnyGroupItem(),
            item1.eraseToAnyGroupItem()
        ]
    }

    public static func buildBlock(
        _ item0: some GroupItem<ItemIdentifier>,
        _ item1: some GroupItem<ItemIdentifier>,
        _ item2: some GroupItem<ItemIdentifier>
    ) -> [AnyGroupItem<ItemIdentifier>] {
        [
            item0.eraseToAnyGroupItem(),
            item1.eraseToAnyGroupItem(),
            item2.eraseToAnyGroupItem()
        ]
    }

    public static func buildBlock(
        _ item0: some GroupItem<ItemIdentifier>,
        _ item1: some GroupItem<ItemIdentifier>,
        _ item2: some GroupItem<ItemIdentifier>,
        _ item3: some GroupItem<ItemIdentifier>
    ) -> [AnyGroupItem<ItemIdentifier>] {
        [
            item0.eraseToAnyGroupItem(),
            item1.eraseToAnyGroupItem(),
            item2.eraseToAnyGroupItem(),
            item3.eraseToAnyGroupItem()
        ]
    }

    public static func buildBlock(
        _ item0: some GroupItem<ItemIdentifier>,
        _ item1: some GroupItem<ItemIdentifier>,
        _ item2: some GroupItem<ItemIdentifier>,
        _ item3: some GroupItem<ItemIdentifier>,
        _ item4: some GroupItem<ItemIdentifier>
    ) -> [AnyGroupItem<ItemIdentifier>] {
        [
            item0.eraseToAnyGroupItem(),
            item1.eraseToAnyGroupItem(),
            item2.eraseToAnyGroupItem(),
            item3.eraseToAnyGroupItem(),
            item4.eraseToAnyGroupItem()
        ]
    }

    public static func buildBlock(
        _ item0: some GroupItem<ItemIdentifier>,
        _ item1: some GroupItem<ItemIdentifier>,
        _ item2: some GroupItem<ItemIdentifier>,
        _ item3: some GroupItem<ItemIdentifier>,
        _ item4: some GroupItem<ItemIdentifier>,
        _ item5: some GroupItem<ItemIdentifier>
    ) -> [AnyGroupItem<ItemIdentifier>] {
        [
            item0.eraseToAnyGroupItem(),
            item1.eraseToAnyGroupItem(),
            item2.eraseToAnyGroupItem(),
            item3.eraseToAnyGroupItem(),
            item4.eraseToAnyGroupItem(),
            item5.eraseToAnyGroupItem()
        ]
    }

    public static func buildBlock(
        _ item0: some GroupItem<ItemIdentifier>,
        _ item1: some GroupItem<ItemIdentifier>,
        _ item2: some GroupItem<ItemIdentifier>,
        _ item3: some GroupItem<ItemIdentifier>,
        _ item4: some GroupItem<ItemIdentifier>,
        _ item5: some GroupItem<ItemIdentifier>,
        _ item6: some GroupItem<ItemIdentifier>
    ) -> [AnyGroupItem<ItemIdentifier>] {
        [
            item0.eraseToAnyGroupItem(),
            item1.eraseToAnyGroupItem(),
            item2.eraseToAnyGroupItem(),
            item3.eraseToAnyGroupItem(),
            item4.eraseToAnyGroupItem(),
            item5.eraseToAnyGroupItem(),
            item6.eraseToAnyGroupItem()
        ]
    }

    public static func buildBlock(
        _ item0: some GroupItem<ItemIdentifier>,
        _ item1: some GroupItem<ItemIdentifier>,
        _ item2: some GroupItem<ItemIdentifier>,
        _ item3: some GroupItem<ItemIdentifier>,
        _ item4: some GroupItem<ItemIdentifier>,
        _ item5: some GroupItem<ItemIdentifier>,
        _ item6: some GroupItem<ItemIdentifier>,
        _ item7: some GroupItem<ItemIdentifier>
    ) -> [AnyGroupItem<ItemIdentifier>] {
        [
            item0.eraseToAnyGroupItem(),
            item1.eraseToAnyGroupItem(),
            item2.eraseToAnyGroupItem(),
            item3.eraseToAnyGroupItem(),
            item4.eraseToAnyGroupItem(),
            item5.eraseToAnyGroupItem(),
            item6.eraseToAnyGroupItem(),
            item7.eraseToAnyGroupItem()
        ]
    }

    public static func buildBlock(
        _ item0: some GroupItem<ItemIdentifier>,
        _ item1: some GroupItem<ItemIdentifier>,
        _ item2: some GroupItem<ItemIdentifier>,
        _ item3: some GroupItem<ItemIdentifier>,
        _ item4: some GroupItem<ItemIdentifier>,
        _ item5: some GroupItem<ItemIdentifier>,
        _ item6: some GroupItem<ItemIdentifier>,
        _ item7: some GroupItem<ItemIdentifier>,
        _ item8: some GroupItem<ItemIdentifier>
    ) -> [AnyGroupItem<ItemIdentifier>] {
        [
            item0.eraseToAnyGroupItem(),
            item1.eraseToAnyGroupItem(),
            item2.eraseToAnyGroupItem(),
            item3.eraseToAnyGroupItem(),
            item4.eraseToAnyGroupItem(),
            item5.eraseToAnyGroupItem(),
            item6.eraseToAnyGroupItem(),
            item7.eraseToAnyGroupItem(),
            item8.eraseToAnyGroupItem()
        ]
    }

    public static func buildBlock(
        _ item0: some GroupItem<ItemIdentifier>,
        _ item1: some GroupItem<ItemIdentifier>,
        _ item2: some GroupItem<ItemIdentifier>,
        _ item3: some GroupItem<ItemIdentifier>,
        _ item4: some GroupItem<ItemIdentifier>,
        _ item5: some GroupItem<ItemIdentifier>,
        _ item6: some GroupItem<ItemIdentifier>,
        _ item7: some GroupItem<ItemIdentifier>,
        _ item8: some GroupItem<ItemIdentifier>,
        _ item9: some GroupItem<ItemIdentifier>
    ) -> [AnyGroupItem<ItemIdentifier>] {
        [
            item0.eraseToAnyGroupItem(),
            item1.eraseToAnyGroupItem(),
            item2.eraseToAnyGroupItem(),
            item3.eraseToAnyGroupItem(),
            item4.eraseToAnyGroupItem(),
            item5.eraseToAnyGroupItem(),
            item6.eraseToAnyGroupItem(),
            item7.eraseToAnyGroupItem(),
            item8.eraseToAnyGroupItem(),
            item9.eraseToAnyGroupItem()
        ]
    }
}
