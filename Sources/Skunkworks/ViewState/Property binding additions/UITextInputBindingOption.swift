
public struct UITextInputBindingOption: OptionSet {

    public static let updatesTextWhenIsFirstResponder = Self(rawValue: 1 << 0)

    public let rawValue: UInt

    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
}
