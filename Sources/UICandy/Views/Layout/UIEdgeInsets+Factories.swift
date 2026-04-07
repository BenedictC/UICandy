import UIKit


public extension UIEdgeInsets {

    init(vertical: CGFloat, horizontal: CGFloat) {
        var insets = Self.zero
        insets.left = horizontal
        insets.top = vertical
        insets.right = horizontal
        insets.bottom = vertical
        self = insets
    }

    static func horizontal(_ value: CGFloat) -> UIEdgeInsets {
        self.init(top: 0, left: value, bottom: 0, right: value)
    }

    static func vertical(_ value: CGFloat) -> UIEdgeInsets {
        self.init(top: value, left: 0, bottom: value, right: 0)
    }

    static func left(_ value: CGFloat) -> UIEdgeInsets { self.init(top: 0, left: value, bottom: 0, right: 0) }
    static func top(_ value: CGFloat) -> UIEdgeInsets { self.init(top: value, left: 0, bottom: 0, right: 0) }
    static func bottom(_ value: CGFloat) -> UIEdgeInsets { self.init(top: 0, left: 0, bottom: value, right: 0) }
    static func right(_ value: CGFloat) -> UIEdgeInsets { self.init(top: 0, left: 0, bottom: 0, right: value) }
}
