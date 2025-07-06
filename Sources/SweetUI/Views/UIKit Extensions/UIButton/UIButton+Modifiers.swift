import UIKit


public extension UIButton {

    func title(_ title: String?, for state: UIControl.State) -> Self {
        setTitle(title, for: state)
        return self
    }
    func titleColor(_ color: UIColor?, for state: UIControl.State) -> Self {
        setTitleColor(color, for: state)
        return self
    }

    func titleShadowColor(_ color: UIColor?, for state: UIControl.State) -> Self {
        setTitleShadowColor(color, for: state)
        return self
    }

    func image(_ image: UIImage?, for state: UIControl.State) -> Self {
        setImage(image, for: state)
        return self
    }

    func backgroundImage(_ image: UIImage?, for state: UIControl.State) -> Self {
        setBackgroundImage(image, for: state)
        return self
    }

    func attributedTitle(_ title: NSAttributedString?, for state: UIControl.State) -> Self {
        setAttributedTitle(title, for: state)
        return self
    }

    func preferredSymbolConfiguration(_ configuration: UIImage.SymbolConfiguration?, forImageIn state: UIControl.State) -> Self {
        setPreferredSymbolConfiguration(configuration, forImageIn: state)
        return self
    }
}


// MARK: - iOS 13.4

@available(iOS 13.4, *)
public extension UIButton {

    func pointerStyleProvider(_ value: UIButton.PointerStyleProvider?) -> Self {
        self.pointerStyleProvider = value
        return self
    }

    func isPointerInteractionEnabled(_ value: Bool) -> Self {
        self.isPointerInteractionEnabled = value
        return self
    }
}


// MARK: - iOS 14.0

@available(iOS 14.0, *)
public extension UIButton {

    func role(_ value: UIButton.Role) -> Self {
        self.role = value
        return self
    }

    func menu(_ value: UIMenu?) -> Self {
        self.menu = value
        self.showsMenuAsPrimaryAction = true
        return self
    }
}


// MARK: - iOS 15.0

@available(iOS 15.0, *)
public extension UIButton {

    func configurationUpdateHandler(_ value: UIButton.ConfigurationUpdateHandler?) -> Self {
        self.configurationUpdateHandler = value
        return self
    }

    func automaticallyUpdatesConfiguration(_ value: Bool) -> Self {
        self.automaticallyUpdatesConfiguration = value
        return self
    }

    func changesSelectionAsPrimaryAction(_ value: Bool) -> Self {
        self.changesSelectionAsPrimaryAction = value
        return self
    }
}


// MARK: - Deprecated

@available(iOS, introduced: 2.0, deprecated: 15.0, message: "This property is ignored when using UIButtonConfiguration")
public extension UIButton {

    func contentEdgeInsets(_ value: UIEdgeInsets) -> Self {
        self.contentEdgeInsets = value
        return self
    }

    func titleEdgeInsets(_ value: UIEdgeInsets) -> Self {
        self.titleEdgeInsets = value
        return self
    }

    func imageEdgeInsets(_ value: UIEdgeInsets) -> Self {
        self.imageEdgeInsets = value
        return self
    }

    func reversesTitleShadowWhenHighlighted(_ value: Bool) -> Self {
        self.reversesTitleShadowWhenHighlighted = value
        return self
    }

    func adjustsImageWhenHighlighted(_ value: Bool) -> Self {
        self.adjustsImageWhenHighlighted = value
        return self
    }

    func adjustsImageWhenDisabled(_ value: Bool) -> Self {
        self.adjustsImageWhenDisabled = value
        return self
    }

    func showsTouchWhenHighlighted(_ value: Bool) -> Self {
        self.showsTouchWhenHighlighted = value
        return self
    }
}
