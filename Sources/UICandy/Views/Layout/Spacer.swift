import UIKit


// MARK: - Spacer

public class Spacer: UIView {

    public init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = false
        addLowestPriorityZeroHeightConstraint()
        addLowestPriorityZeroWidthConstraint()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Factories

public extension Spacer {

    convenience init(
        minWidth: CGFloat? = nil,
        idealWidth: CGFloat? = nil,
        idealWidthPriority: UILayoutPriority = .defaultHigh,
        maxWidth: CGFloat? = nil,
        minHeight: CGFloat? = nil,
        idealHeight: CGFloat? = nil,
        idealHeightPriority: UILayoutPriority = .defaultHigh,
        maxHeight: CGFloat? = nil)
    {
        self.init()
        _ = self.frame(minWidth: minWidth, idealWidth: idealWidth, idealWidthPriority: idealWidthPriority, maxWidth: maxWidth, minHeight: minHeight, idealHeight: idealHeight, idealHeightPriority: idealHeightPriority, maxHeight: maxHeight)
        if minWidth == nil, idealWidth == nil, maxWidth == nil {
            addLowestPriorityZeroWidthConstraint()
        }
        if minHeight == nil, idealHeight == nil, maxHeight == nil {
            addLowestPriorityZeroHeightConstraint()
        }
    }

    convenience init(width: CGFloat, height: CGFloat? = nil) {
        self.init()
        _ = self.frame(width: width, height: height)
        if height == nil {
            addLowestPriorityZeroHeightConstraint()
        }
    }

    convenience init(height: CGFloat) {
        self.init()
        _ = self.frame(height: height)
        addLowestPriorityZeroWidthConstraint()
    }

    private func addLowestPriorityZeroWidthConstraint() {
        let widthConstraint = heightAnchor.constraint(equalToConstant: 0)
        widthConstraint.priority = UILayoutPriority(1)
        widthConstraint.isActive = true
    }

    private func addLowestPriorityZeroHeightConstraint() {
        let heightConstraint = heightAnchor.constraint(equalToConstant: 0)
        heightConstraint.priority = UILayoutPriority(1)
        heightConstraint.isActive = true
    }
}
