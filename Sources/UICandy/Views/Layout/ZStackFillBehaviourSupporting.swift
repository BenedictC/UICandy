import UIKit

// MARK: - ZStackFillBehaviourSupporting

public protocol ZStackFillBehaviourSupporting: UIView {
    var zStackFillAxes: Axis { get }
}


// MARK: - Internal UIView additions

extension ZStack {

    static func zStackFillAxes(for view: UIView) -> Axis {
        if let view = view as? ZStackFillBehaviourSupporting {
            return view.zStackFillAxes
        }
        if view is UIScrollView {
            // This could be cause a problem if the scrollView has its frame constrained.
            // The fix would be to wrap the scrollView in a ZStackFillBehaviourAdjustmentContainer.
            return .both
        }
        if let subview = view.subviews.first {
            return zStackFillAxes(for: subview)
        }
        return .none
    }

    static func fillsZStack(axis: Axis, view: UIView) -> Bool {
        let fills = zStackFillAxes(for: view)
        return fills.contains(axis)
    }
}
