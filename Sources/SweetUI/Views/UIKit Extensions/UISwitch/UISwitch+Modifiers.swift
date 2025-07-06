import UIKit


public extension UISwitch {

    func onTintColor(_ value: UIColor?) -> Self {
        self.onTintColor = value
        return self
    }

    func thumbTintColor(_ value: UIColor?) -> Self {
        self.thumbTintColor = value
        return self
    }

    func onImage(_ value: UIImage?) -> Self {
        self.onImage = value
        return self
    }

    func offImage(_ value: UIImage?) -> Self {
        self.offImage = value
        return self
    }

    func isOn(_ value: Bool) -> Self {
        // does not send action
        self.isOn = value
        return self
    }

    func isOn(_ value: Bool, animated: Bool) -> Self {
        // does not send action
        self.setOn(value, animated: animated)
        return self
    }
}


@available(iOS 14.0, *)
public extension UISwitch {

    func preferredStyle(_ value: UISwitch.Style) -> Self {
        self.preferredStyle = value
        return self
    }
}
