import UIKit


public extension UIStepper {

    func isContinuous(_ value: Bool) -> Self {
        self.isContinuous = value
        return self
    }

    func autorepeat(_ value: Bool) -> Self {
        self.autorepeat = value
        return self
    }

    func wraps(_ value: Bool) -> Self {
        self.wraps = value
        return self
    }

    // default is 0. sends UIControlEventValueChanged. clamped to min/max
    func value(_ value: Double) -> Self {
        self.value = value
        return self
    }

    func minimumValue(_ value: Double) -> Self {
        self.minimumValue = value
        return self
    }

    func maximumValue(_ value: Double) -> Self {
        self.maximumValue = value
        return self
    }

    func stepValue(_ value: Double) -> Self {
        self.stepValue = value
        return self
    }

    func backgroundImage(_ image: UIImage?, for state: UIControl.State) -> Self {
        self.setBackgroundImage(image, for: state)
        return self
    }

    func dividerImage(_ image: UIImage?, forLeftSegmentState leftState: UIControl.State, rightSegmentState rightState: UIControl.State) -> Self {
        self.setDividerImage(image, forLeftSegmentState: leftState, rightSegmentState: rightState)
        return self
    }

    func incrementImage(_ image: UIImage?, for state: UIControl.State) -> Self {
        self.setIncrementImage(image, for: state)
        return self
    }

    func decrementImage(_ image: UIImage?, for state: UIControl.State) -> Self {
        self.setDecrementImage(image, for: state)
        return self
    }
}
