struct UniqueIdentifier: Hashable {

    static private var count = 0

    let value: String

    init(_ prefix: String) {
        value = "\(prefix):\(Self.count)"
        Self.count += 1
    }
}
