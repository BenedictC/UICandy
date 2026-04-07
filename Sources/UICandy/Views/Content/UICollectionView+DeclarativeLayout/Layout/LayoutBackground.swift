import UIKit


public struct LayoutBackground {

    let view: UIView

    public init(view: () -> UIView) {
        self.view = view()
    }
}
