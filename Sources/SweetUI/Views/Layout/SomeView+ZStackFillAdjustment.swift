import UIKit


public class ZStackFillAdjustmentContainer<T: UIView>: Container<T>, ZStackFillBehaviourSupporting, EdgesIgnoringSafeAreaSupporting {

    // MARK: Properties

    let optionalZStackFillAxes: Axis?
    public var zStackFillAxes: Axis {
        optionalZStackFillAxes ?? ZStack.zStackFillAxes(for: content)
    }

    public var edgesIgnoringSafeArea: UIRectEdge { UIView.edgesIgnoringSafeArea(for: content) }


    // MARK: Instance life cycle

    init(content: T, zStackFillAxes: Axis?) {
        self.optionalZStackFillAxes = zStackFillAxes
        super.init(content: content)

        addAndFill(subview: content, overrideEdgesIgnoringSafeArea: .all)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: -

public extension SomeView {

    func zStackFillAxes(_ axes: Axis) -> ZStackFillAdjustmentContainer<Self> {
        return ZStackFillAdjustmentContainer(content: self, zStackFillAxes: axes)
    }
}
