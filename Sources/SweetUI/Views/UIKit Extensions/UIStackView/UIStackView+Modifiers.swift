import UIKit


public extension UIStackView {

    func axis(_ value: NSLayoutConstraint.Axis) -> Self {
        axis = value
        return self
    }

    func distribution(_ value: UIStackView.Distribution) -> Self {
        distribution = value
        return self
    }

    func alignment(_ value: UIStackView.Alignment) -> Self {
        alignment = value
        return self
    }

    func spacing(_ value: CGFloat) -> Self {
        spacing = value
        return self
    }

    func baselineRelativeArrangement(_ value: Bool) -> Self {
        isBaselineRelativeArrangement = value
        return self
    }

    func layoutMarginsRelativeArrangement(_ value: Bool) -> Self {
        isLayoutMarginsRelativeArrangement = value
        return self
    }
}
