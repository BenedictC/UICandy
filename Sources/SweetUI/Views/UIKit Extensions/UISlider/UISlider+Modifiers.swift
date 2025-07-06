import UIKit


public extension UISlider {

    func value(_ value: Float) -> Self {
        self.value = value
        return self
    }

    func minimumValue(_ value: Float) -> Self {
        minimumValue = value
        return self
    }

    func maximumValue(_ value: Float) -> Self {
        maximumValue = value
        return self
    }

    func minimumValueImage(_ value: UIImage) -> Self {
        minimumValueImage = value
        return self
    }

    func maximumValueImage(_ value: UIImage) -> Self {
        maximumValueImage = value
        return self
    }

    func continuous(_ value: Bool) -> Self {
        isContinuous = value
        return self
    }

    func minimumTrackTintColor(_ value: UIColor) -> Self {
        minimumTrackTintColor = value
        return self
    }

    func maximumTrackTintColor(_ value: UIColor) -> Self {
        maximumTrackTintColor = value
        return self
    }

    func thumbTintColor(_ value: UIColor) -> Self {
        thumbTintColor = value
        return self
    }

    func thumbImage(_ value: UIImage?, for state: UIControl.State) -> Self {
        setThumbImage(value, for: state)
        return self
    }

    func minimumTrackImage(_ value: UIImage?, for state: UIControl.State) -> Self {
        setMinimumTrackImage(value, for: state)
        return self
    }

    func maximumTrackImage(_ value: UIImage?, for state: UIControl.State) -> Self {
        setMaximumTrackImage(value, for: state)
        return self
    }
}


// MARK: - Additions

public extension SomeView where Self: UISlider {

    @available(iOS 14.0, *)
    func withValueSnappedToIncrements(of increment: Float, handler: @escaping (Self, Float) -> Void) -> Self {
        self.onEvent(.valueChanged, perform: { slider in
            let initialValue = slider.value
            let unroundedOffset = initialValue - slider.minimumValue
            let remainder = unroundedOffset.remainder(dividingBy: increment)
            let downDistance = remainder
            let upDistance = increment - remainder
            let shouldRoundUp = upDistance < downDistance
            let offset = (increment * Float(Int(unroundedOffset / increment))) + (shouldRoundUp ? increment : 0)
            let value = slider.minimumValue + offset
            assert(value >= slider.minimumValue)
            assert(value <= slider.maximumValue)
            handler(slider, value)
        })
    }
}
