import UIKit


public extension SomeView {

    func frame(width: CGFloat, height: CGFloat? = nil) -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        constraints.append(widthAnchor.constraint(equalToConstant: width))
        if let height = height {
            constraints.append(heightAnchor.constraint(equalToConstant: height))
        }
        NSLayoutConstraint.activate(constraints)
        return self
    }

    func frame(height: CGFloat) -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: height)
        ])
        return self
    }

    func frame(minWidth: CGFloat? = nil,
               idealWidth: CGFloat? = nil,
               idealWidthPriority: UILayoutPriority = .defaultHigh,
               maxWidth: CGFloat? = nil,
               minHeight: CGFloat? = nil,
               idealHeight: CGFloat? = nil,
               idealHeightPriority: UILayoutPriority = .defaultHigh,
               maxHeight: CGFloat? = nil) -> Self
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()

        if let minWidth = minWidth {
            constraints.append(widthAnchor.constraint(greaterThanOrEqualToConstant: minWidth))
        }
        if let idealWidth = idealWidth {
            let constraint = widthAnchor.constraint(equalToConstant: idealWidth)
            constraint.priority = idealWidthPriority
            constraints.append(constraint)
        }
        if let maxWidth = maxWidth {
            constraints.append(widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth))
        }
        if let minHeight = minHeight {
            constraints.append(heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight))
        }
        if let idealHeight = idealHeight {
            let constraint = heightAnchor.constraint(equalToConstant: idealHeight)
            constraint.priority = idealHeightPriority
            constraints.append(constraint)
        }
        if let maxHeight = maxHeight {
            constraints.append(heightAnchor.constraint(lessThanOrEqualToConstant: maxHeight))
        }

        NSLayoutConstraint.activate(constraints)
        return self
    }
}
