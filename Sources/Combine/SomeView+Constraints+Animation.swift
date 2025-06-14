import UIKit
import Combine


// MARK: - Constraints creation

@MainActor
public extension SomeView {
    
    func constraints<V>(
        for publisher: some Publisher<V, Never>,
        animatorFactory: @MainActor @escaping () -> UIViewPropertyAnimator = { UIViewPropertyAnimator(duration: 0.3, curve: .easeOut) },
        constraintsFactory: @escaping (Self, V, [NSLayoutConstraint]) -> [NSLayoutConstraint]
    ) -> Self {
        var activeConstraints = [NSLayoutConstraint]()
        
        publisher.sink { [weak self] value in
            guard let self else { return }
            let staleConstraints = activeConstraints
            let freshConstraints = constraintsFactory(self, value, staleConstraints)
            NSLayoutConstraint.deactivate(staleConstraints)
            NSLayoutConstraint.activate(freshConstraints)
            activeConstraints = freshConstraints
            if self.window != nil {
                self.setNeedsLayout()
                let animator = animatorFactory()
                animator.addAnimations { self.layoutIfNeeded() }
                animator.startAnimation()
            }
        }
        .store(in: .current)
        return self
    }
}


// MARK: - Constraint updating

@MainActor
public extension SomeView {
    
    func constraint(
        active publisher: some Publisher<Bool, Never>,
        animatorFactory: @MainActor @escaping () -> UIViewPropertyAnimator = { UIViewPropertyAnimator.makeDefaultAnimator() },
        constraint constraintBuilder: (Self) -> NSLayoutConstraint
    )
    -> Self {
        let constraint = constraintBuilder(self)
        
        publisher.sink { isActive in
            guard constraint.isActive != isActive else { return }
            constraint.isActive = isActive
            
            let container = UIView.viewToLayout(for: constraint)
            guard let container, container.window != nil else { return }
            let animator = animatorFactory()
            animator.addAnimations { container.layoutIfNeeded() }
            animator.startAnimation()
        }
        .store(in: .current)
        return self
    }
    
    func constraint(
        constant publisher: some Publisher<CGFloat, Never>,
        animatorFactory: @MainActor @escaping () -> UIViewPropertyAnimator = { UIViewPropertyAnimator.makeDefaultAnimator() },
        constraint constraintBuilder: (Self) -> NSLayoutConstraint
    ) -> Self {
        let constraint = constraintBuilder(self)
        publisher.sink { constant in
            guard constraint.constant != constant else { return }
            constraint.constant = constant
            
            let container = UIView.viewToLayout(for: constraint)
            guard let container, container.window != nil else { return }
            let animator = animatorFactory()
            animator.addAnimations { container.layoutIfNeeded() }
            animator.startAnimation()
        }
        .store(in: .current)
        return self
    }
}


// MARK: - Helpers

private extension UIView {
    
    var ancestors: [UIView] {
        var ancestors = [UIView]()
        var ancestor = superview
        while let next = ancestor {
            ancestors.append(next)
            ancestor = next.superview
        }
        return ancestors
    }
    
    static func viewToLayout(for constraints: [NSLayoutConstraint]) -> UIView? {
        var candidates = Set(constraints.compactMap { viewToLayout(for: $0) })
        guard !candidates.isEmpty else { return nil }
        
        var bestFit = candidates.removeFirst()
        var ancestorsOfBestFit = bestFit.ancestors
        while let contender = candidates.first{
            candidates.remove(contender)
            // #
            let ancestorsOfContender = contender.ancestors
            let isBestFitAnAncestorOfContender = ancestorsOfContender.contains(bestFit)
            if isBestFitAnAncestorOfContender {
                continue
            }
            // #
            let isContenderAnAncestorOfBestFit = ancestorsOfBestFit.contains(contender)
            if isContenderAnAncestorOfBestFit {
                bestFit = contender
                ancestorsOfBestFit = ancestorsOfContender
                continue
            }
            // #
            // Find the nearest shared ancestor
            for index in 0..<min(ancestorsOfContender.count, ancestorsOfBestFit.count) {
                if ancestorsOfContender[index] == ancestorsOfBestFit[index] {
                    continue
                }
                guard index > 0 else {
                    // Views belong in different hierarchies.
                    break
                }
                bestFit = ancestorsOfContender[index - 1]
                ancestorsOfBestFit = bestFit.ancestors
                break
            }
        }
        return bestFit
    }
    
    static func viewToLayout(for constraint: NSLayoutConstraint) -> UIView? {
        let firstView = constraint.firstItem as? UIView
        let secondView = constraint.secondItem as? UIView
        let primary = firstView ?? secondView
        let result = primary?.nearestCommonAncestor(with: secondView)
        return result
    }
    
    func nearestCommonAncestor(with other: UIView?) -> UIView? {
        guard let other = other else { return superview }
        if self == other { return superview }
        
        let ancestors = self.ancestors
        let otherAncestors = other.ancestors
        let viewDepth = min(ancestors.count, otherAncestors.count)
        guard viewDepth > 0 else { return nil }
        var lastMatch: UIView?
        for i in 1..<viewDepth {
            let ancestor = ancestors[ancestors.count - i]
            let otherAncestor = otherAncestors[otherAncestors.count - i]
            guard ancestor == otherAncestor else {
                break
            }
            lastMatch = ancestor
        }
        if lastMatch == self {
            return self.superview
        }
        if lastMatch == other {
            return other.superview
        }
        return lastMatch
    }
}


public extension UIViewPropertyAnimator {
    
    @MainActor
    static func makeDefaultAnimator() -> UIViewPropertyAnimator {
        UIViewPropertyAnimator(duration: 0.3, curve: .easeOut)
    }
}
