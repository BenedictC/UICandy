public struct Axis: OptionSet {

    public let rawValue: UInt

    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }

    public static let vertical = Self(rawValue: 1 << 0)
    public static let horizontal = Self(rawValue: 1 << 1)
    public static let both: Self = [Self.vertical, Self.horizontal]
    public static let none: Self = []
}
