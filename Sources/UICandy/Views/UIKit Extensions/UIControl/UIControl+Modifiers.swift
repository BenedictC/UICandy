import UIKit


// MARK: - Modifiers

public extension UIControl {

    func enabled(_ value: Bool) -> Self {
        self.isEnabled = value
        return self
    }

    func selected(_ value: Bool) -> Self {
        self.isSelected = value
        return self
    }

    func highlighted(_ value: Bool) -> Self {
        self.isHighlighted = value
        return self
    }

    func contentVerticalAlignment(_ value: UIControl.ContentVerticalAlignment) -> Self {
        self.contentVerticalAlignment = value
        return self
    }

    func contentHorizontalAlignment(_ value: UIControl.ContentHorizontalAlignment) -> Self {
        self.contentHorizontalAlignment = value
        return self
    }

    @available(iOS 14.0, *)
    func contextMenuInteractionEnabled(_ value: Bool) -> Self {
        self.isContextMenuInteractionEnabled = value
        return self
    }

    @available(iOS 14.0, *)
    func showsMenuAsPrimaryAction(_ value: Bool) -> Self {
        self.showsMenuAsPrimaryAction = value
        return self
    }

    @available(iOS 15.0, *)
    func toolTip(_ value: String) -> Self {
        self.toolTip = value
        return self
    }
}



public extension UIControl {

    func disabled(_ value: Bool) -> Self {
        self.enabled(!value)
    }
}
