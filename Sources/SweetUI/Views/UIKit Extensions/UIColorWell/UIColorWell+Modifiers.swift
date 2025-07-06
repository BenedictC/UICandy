import UIKit


@available(iOS 14.0, *)
public extension UIColorWell {

    func title(_ value: String?) -> Self {
        title = value
        return self
    }

    func supportsAlpha(_ value: Bool) -> Self {
        supportsAlpha = value
        return self
    }

    func selectedColor(_ value: UIColor?) -> Self {
        selectedColor = value
        return self
    }
}
