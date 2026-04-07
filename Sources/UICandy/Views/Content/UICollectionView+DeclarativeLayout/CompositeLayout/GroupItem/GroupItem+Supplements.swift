
public extension GroupItem {

    func supplements(
        @ArrayBuilder<Supplement<ItemIdentifier>>
        _ supplementsBuilder: () -> [Supplement<ItemIdentifier>]
    ) -> SupplementedGroupItem<ItemIdentifier> {
        let supplements = supplementsBuilder()
        return SupplementedGroupItem(groupItem: self.eraseToAnyGroupItem(), supplements: supplements)
    }
}

