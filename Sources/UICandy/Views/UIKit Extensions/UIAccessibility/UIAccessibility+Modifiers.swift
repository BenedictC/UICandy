import UIKit


public extension UIView {

    func accessibilityIdentifier(_ value: String) -> Self {
        self.accessibilityIdentifier = value
        return self
    }

    func isAccessibilityElement(_ value: Bool) -> Self {
        self.isAccessibilityElement = value
        return self
    }

    func accessibilityLabel(_ value: String) -> Self {
        self.accessibilityLabel = value
        return self
    }

    func accessibilityAttributedLabel(_ value: NSAttributedString) -> Self {
        self.accessibilityAttributedLabel = value
        return self
    }

    func accessibilityHint(_ value: String) -> Self {
        self.accessibilityHint = value
        return self
    }

    func accessibilityAttributedHint(_ value: NSAttributedString) -> Self {
        self.accessibilityAttributedHint = value
        return self
    }

    func accessibilityValue(_ value: String) -> Self {
        self.accessibilityValue = value
        return self
    }

    func accessibilityAttributedValue(_ value: NSAttributedString) -> Self {
        self.accessibilityAttributedValue = value
        return self
    }

    func accessibilityTraits(_ value: UIAccessibilityTraits) -> Self {
        self.accessibilityTraits = value
        return self
    }

    func accessibilityFrame(_ value: CGRect) -> Self {
        self.accessibilityFrame = value
        return self
    }

    func accessibilityPath(_ value: UIBezierPath) -> Self {
        self.accessibilityPath = value
        return self
    }

    func accessibilityActivationPoint(_ value: CGPoint) -> Self {
        self.accessibilityActivationPoint = value
        return self
    }

    func accessibilityLanguage(_ value: String) -> Self {
        self.accessibilityLanguage = value
        return self
    }

    func accessibilityElementsHidden(_ value: Bool) -> Self {
        self.accessibilityElementsHidden = value
        return self
    }

    func accessibilityViewIsModal(_ value: Bool) -> Self {
        self.accessibilityViewIsModal = value
        return self
    }

    func shouldGroupAccessibilityChildren(_ value: Bool) -> Self {
        self.shouldGroupAccessibilityChildren = value
        return self
    }

    func accessibilityNavigationStyle(_ value: UIAccessibilityNavigationStyle) -> Self {
        self.accessibilityNavigationStyle = value
        return self
    }

    func accessibilityRespondsToUserInteraction(_ value: Bool) -> Self {
        self.accessibilityRespondsToUserInteraction = value
        return self
    }


    func accessibilityUserInputLabels(_ value: [String]) -> Self {
        self.accessibilityUserInputLabels = value
        return self
    }

    func accessibilityAttributedUserInputLabels(_ value: [NSAttributedString]) -> Self {
        self.accessibilityAttributedUserInputLabels = value
        return self
    }
}


@available(iOS 13.0, *)
extension UIView {

    func accessibilityTextualContext(_ value: UIAccessibilityTextualContext) -> Self {
        self.accessibilityTextualContext = value
        return self
    }
}


// MARK: - UIAccessibilityAction

public extension UIView {

    func accessibilityCustomActions(_ value: [UIAccessibilityCustomAction]?) -> Self {
        accessibilityCustomActions = value
        return self
    }
}


// MARK: - UIAccessibilityDragging

public extension UIView {

    func accessibilityDragSourceDescriptors(_ value: [UIAccessibilityLocationDescriptor]?) -> Self {
        accessibilityDragSourceDescriptors = value
        return self
    }

    func accessibilityDropPointDescriptors(_ value: [UIAccessibilityLocationDescriptor]) -> Self {
        accessibilityDropPointDescriptors = value
        return self
    }
}
