import UIKit


public extension UIView {

    func userInteractionEnabled(_ value: Bool) -> Self {
        self.isUserInteractionEnabled = value
        return self
    }

    func tag(_ value: Int) -> Self {
        self.tag = value
        return self
    }

    func transform(_ value: CGAffineTransform) -> Self {
        self.transform = value
        return self
    }

    func multipleTouchEnabled(_ value: Bool) -> Self {
        self.isMultipleTouchEnabled = value
        return self
    }

    func exclusiveTouch(_ value: Bool) -> Self {
        self.isExclusiveTouch = value
        return self
    }

    func clipsToBounds(_ value: Bool) -> Self {
        self.clipsToBounds = value
        return self
    }

    func backgroundColor(_ value: UIColor?) -> Self {
        self.backgroundColor = value
        return self
    }

    func alpha(_ value: CGFloat) -> Self {
        self.alpha = value
        return self
    }

    func opaque(_ value: Bool) -> Self {
        self.isOpaque = value
        return self
    }

    func clearsContextBeforeDrawing(_ value: Bool) -> Self {
        self.clearsContextBeforeDrawing = value
        return self
    }

    func hidden(_ value: Bool) -> Self {
        self.isHidden = value
        return self
    }

    func contentMode(_ value: UIView.ContentMode) -> Self {
        self.contentMode = value
        return self
    }

    func semanticContentAttribute(_ value: UISemanticContentAttribute) -> Self {
        self.semanticContentAttribute = value
        return self
    }

    func transform3D(_ value: CATransform3D) -> Self {
        self.transform3D = value
        return self
    }

    func contentScaleFactor(_ value: CGFloat) -> Self {
        self.contentScaleFactor = value
        return self
    }

    func layoutMargins(_ value: UIEdgeInsets) -> Self {
        self.layoutMargins = value
        return self
    }

    func directionalLayoutMargins(_ value: NSDirectionalEdgeInsets) -> Self {
        self.directionalLayoutMargins = value
        return self
    }

    func preservesSuperviewLayoutMargins(_ value: Bool) -> Self {
        self.preservesSuperviewLayoutMargins = value
        return self
    }

    func insetsLayoutMarginsFromSafeArea(_ value: Bool) -> Self {
        self.insetsLayoutMarginsFromSafeArea = value
        return self
    }

    func mask(_ value: UIView?) -> Self {
        self.mask = value
        return self
    }

    func tintColor(_ value: UIColor!) -> Self {
        self.tintColor = value
        return self
    }

    func tintAdjustmentMode(_ value: UIView.TintAdjustmentMode) -> Self {
        self.tintAdjustmentMode = value
        return self
    }

    func overrideUserInterfaceStyle(_ value: UIUserInterfaceStyle) -> Self {
        self.overrideUserInterfaceStyle = value
        return self
    }

    func translatesAutoresizingMaskIntoConstraints(_ value: Bool) -> Self {
        self.translatesAutoresizingMaskIntoConstraints = value
        return self
    }
}


@available(iOS 14.0, *)
public extension UIView {

    func focusGroupIdentifier(_ value: String?) -> Self {
        self.focusGroupIdentifier = value
        return self
    }
}


@available(iOS 15.0, *)
public extension UIView {

    func minimumContentSizeCategory(_ value: UIContentSizeCategory?) -> Self {
        self.minimumContentSizeCategory = value
        return self
    }

    func maximumContentSizeCategory(_ value: UIContentSizeCategory?) -> Self {
        self.maximumContentSizeCategory = value
        return self
    }

    func focusGroupPriority(_ value: UIFocusGroupPriority) -> Self {
        self.focusGroupPriority = value
        return self
    }

    func focusEffect(_ value: UIFocusEffect?) -> Self {
        self.focusEffect = value
        return self
    }
}


// MARK: - Layer

public extension UIView {

    func configureLayer(using closure: (CALayer) -> Void) -> Self {
        closure(layer)
        return self
    }
}
