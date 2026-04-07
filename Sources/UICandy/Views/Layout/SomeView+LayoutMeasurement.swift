import UIKit


public extension SomeView {

    @discardableResult
    func contentHugs(in axis: Axis, at priority: UILayoutPriority) -> Self {
        if axis.contains(.horizontal) {
            setContentHuggingPriority(priority, for: .horizontal)
        }
        if axis.contains(.vertical) {
            setContentHuggingPriority(priority, for: .vertical)
        }
        return self
    }

    @discardableResult
    func contentResistsCompression(in axis: Axis, at priority: UILayoutPriority) -> Self {
        if axis.contains(.horizontal) {
            setContentCompressionResistancePriority(priority, for: .horizontal)
        }
        if axis.contains(.vertical) {
            setContentCompressionResistancePriority(priority, for: .vertical)
        }
        return self
    }
}
