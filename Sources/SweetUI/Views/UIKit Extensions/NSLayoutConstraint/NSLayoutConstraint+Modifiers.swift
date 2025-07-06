import UIKit


public extension UILayoutPriority {

    static let almostRequired = UILayoutPriority(rawValue: 999)
    static let lowest = UILayoutPriority(rawValue: 1)
}


public extension NSLayoutConstraint {

    static func aspectConstraint(view: UIView, relatedBy: NSLayoutConstraint.Relation = .equal, multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
        NSLayoutConstraint(item: view, attribute: .width, relatedBy: relatedBy, toItem: view, attribute: .height, multiplier: multiplier, constant: constant)
    }

    func active(_ value: Bool) -> Self {
        self.isActive = value
        return self
    }

    func constant(_ value: CGFloat) -> Self {
        self.constant = value
        return self
    }

    func identifier(_ value: String?) -> Self {
        self.identifier = value
        return self
    }

    func priority(_ value: UILayoutPriority) -> Self {
        self.priority = value
        return self
    }
}
