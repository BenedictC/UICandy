import UIKit


// MARK: - Single constraints

public extension SomeView {

    func constrain(_ attribute1: NSLayoutConstraint.Attribute, of item1: Any, to attribute2: NSLayoutConstraint.Attribute, of item2: Any?, relatedBy: NSLayoutConstraint.Relation = .equal, multiplier: CGFloat = 1, constant: CGFloat = 0, activate: Bool = true, priority: UILayoutPriority = .required, completion: (NSLayoutConstraint) -> Void = { _ in }) -> Self {
        let constraint = NSLayoutConstraint(item: item1, attribute: attribute1, relatedBy: relatedBy, toItem: item2, attribute: attribute2, multiplier: multiplier, constant: constant)
        constraint.priority = priority
        constraint.isActive = activate
        completion(constraint)
        return self
    }

    func constrainWidth(of item1: Any, to attribute2: NSLayoutConstraint.Attribute = .width, of optionalItem2: Any? = nil, relatedBy: NSLayoutConstraint.Relation = .equal, multiplier: CGFloat = 1, constant: CGFloat = 0, activate: Bool = true, priority: UILayoutPriority = .required, completion: (NSLayoutConstraint) -> Void = { _ in }) -> Self {
        let item2 = optionalItem2 ?? self.safeAreaLayoutGuide
        let attribute1 = NSLayoutConstraint.Attribute.width
        let constraint = NSLayoutConstraint(item: item1, attribute: attribute1, relatedBy: relatedBy, toItem: item2, attribute: attribute2, multiplier: multiplier, constant: constant)
        constraint.priority = priority
        constraint.isActive = activate
        completion(constraint)
        return self
    }

    func constrainHeight(of item1: Any, to attribute2: NSLayoutConstraint.Attribute = .height, of optionalItem2: Any? = nil, relatedBy: NSLayoutConstraint.Relation = .equal, multiplier: CGFloat = 1, constant: CGFloat = 0, activate: Bool = true, priority: UILayoutPriority = .required, completion: (NSLayoutConstraint) -> Void = { _ in }) -> Self {
        let item2 = optionalItem2 ?? self.safeAreaLayoutGuide
        let attribute1 = NSLayoutConstraint.Attribute.height
        let attribute2 = NSLayoutConstraint.Attribute.height
        let constraint = NSLayoutConstraint(item: item1, attribute: attribute1, relatedBy: relatedBy, toItem: item2, attribute: attribute2, multiplier: multiplier, constant: constant)
        constraint.priority = priority
        constraint.isActive = activate
        completion(constraint)
        return self
    }

    func constrainCenterX(of item1: Any, to attribute2: NSLayoutConstraint.Attribute = .centerX, of optionalItem2: Any? = nil, relatedBy: NSLayoutConstraint.Relation = .equal, multiplier: CGFloat = 1, constant: CGFloat = 0, activate: Bool = true, priority: UILayoutPriority = .required, completion: (NSLayoutConstraint) -> Void = { _ in }) -> Self {
        let item2 = optionalItem2 ?? self.safeAreaLayoutGuide
        let attribute1 = NSLayoutConstraint.Attribute.centerX
        let constraint = NSLayoutConstraint(item: item1, attribute: attribute1, relatedBy: relatedBy, toItem: item2, attribute: attribute2, multiplier: multiplier, constant: constant)
        constraint.priority = priority
        constraint.isActive = activate
        completion(constraint)
        return self
    }

    func constrainCenterY(of item1: Any, to attribute2: NSLayoutConstraint.Attribute = .centerY, of optionalItem2: Any? = nil, relatedBy: NSLayoutConstraint.Relation = .equal, multiplier: CGFloat = 1, constant: CGFloat = 0, activate: Bool = true, priority: UILayoutPriority = .required, completion: (NSLayoutConstraint) -> Void = { _ in }) -> Self {
        let item2 = optionalItem2 ?? self.safeAreaLayoutGuide
        let attribute1 = NSLayoutConstraint.Attribute.centerY
        let constraint = NSLayoutConstraint(item: item1, attribute: attribute1, relatedBy: relatedBy, toItem: item2, attribute: attribute2, multiplier: multiplier, constant: constant)
        constraint.priority = priority
        constraint.isActive = activate
        completion(constraint)
        return self
    }

    func constrainAspectRatio(relatedBy: NSLayoutConstraint.Relation = .equal, multiplier: CGFloat = 1, constant: CGFloat = 0, activate: Bool = true, priority: UILayoutPriority = .required, completion: (NSLayoutConstraint) -> Void = { _ in }) -> Self {
        let constraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: relatedBy, toItem: self, attribute: .height, multiplier: multiplier, constant: constant)
        constraint.priority = priority
        constraint.isActive = activate
        completion(constraint)
        return self
    }
}


// MARK: - Multiple constraints

public extension SomeView {

    // With self

    func constraints(@ArrayBuilder<NSLayoutConstraint> _ builder: (Self) -> [NSLayoutConstraint]) -> Self {
        var ignore: [NSLayoutConstraint]? = nil
        return constraints(storeIn: &ignore, builder)
    }

    func constraints(storeIn: inout [NSLayoutConstraint]?, @ArrayBuilder<NSLayoutConstraint> _ builder: (Self) -> [NSLayoutConstraint]) -> Self {
        let constraints = builder(self)
        NSLayoutConstraint.activate(constraints)
        return self
    }


    // Without self

    func constraints(@ArrayBuilder<NSLayoutConstraint> _ builder: () -> [NSLayoutConstraint]) -> Self {
        var ignore: [NSLayoutConstraint]? = nil
        return constraints(storeIn: &ignore, builder)
    }

    func constraints(storeIn ref: inout [NSLayoutConstraint]?, @ArrayBuilder<NSLayoutConstraint> _ builder: () -> [NSLayoutConstraint]) -> Self {
        let constraints = builder()
        NSLayoutConstraint.activate(constraints)
        ref = constraints
        return self
    }
}
