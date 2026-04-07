import UIKit


// MARK: - Definitions

public struct PreferredFont: Sendable {
    public let font: UIFont

    public static let largeTitle = Self(font: .preferredFont(forTextStyle: .largeTitle))
    public static let title1 = Self(font: .preferredFont(forTextStyle: .title1))
    public static let title2 = Self(font: .preferredFont(forTextStyle: .title2))
    public static let title3 = Self(font: .preferredFont(forTextStyle: .title3))
    public static let headline = Self(font: .preferredFont(forTextStyle: .headline))
    public static let subheadline = Self(font: .preferredFont(forTextStyle: .subheadline))
    public static let body = Self(font: .preferredFont(forTextStyle: .body))
    public static let callout = Self(font: .preferredFont(forTextStyle: .callout))
    public static let footnote = Self(font: .preferredFont(forTextStyle: .footnote))
    public static let caption1 = Self(font: .preferredFont(forTextStyle: .caption1))
    public static let caption2 = Self(font: .preferredFont(forTextStyle: .caption2))
}


// MARK: - UILabel

public extension UILabel {

    func font(_ value: PreferredFont) -> Self {
        self.font = value.font
        return self
    }
}


// MARK: - UITextField

public extension UITextField {

    func font(_ value: PreferredFont) -> Self {
        self.font = value.font
        return self
    }
}


// MARK: - UITextView

public extension UITextView {

     func font(_ value: PreferredFont) -> Self {
        self.font = value.font
        return self
    }
}
