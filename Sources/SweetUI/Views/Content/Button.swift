import UIKit


public final class Button<Body: UIView>: Control {

    // MARK: Properties

    public var body: Body { _body }
    private var _body: Body!


    // MARK: Instance life cycle

    public init(body bodyFactory: (any Control) -> Body) {
        super.init()
        self.accessibilityTraits = [.button]
        self._body = bodyFactory(self)
    }
}
