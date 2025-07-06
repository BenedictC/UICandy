import UIKit


public extension UIDatePicker {

    func datePickerMode(_ value: UIDatePicker.Mode) -> Self {
        datePickerMode = value
        return self
    }

    func locale(_ value: Locale?) -> Self {
        locale = value
        return self
    }

    func calendar(_ value: Calendar?) -> Self {
        calendar = value
        return self
    }

    func timeZone(_ value: TimeZone?) -> Self {
        timeZone = value
        return self
    }

    func date(_ value: Date) -> Self {
        date = value
        return self
    }

    func minimumDate(_ value: Date?) -> Self {
        minimumDate = value
        return self
    }

    func maximumDate(_ value: Date?) -> Self {
        maximumDate = value
        return self
    }

    func countDownDuration(_ value: TimeInterval) -> Self {
        countDownDuration = value
        return self
    }

    func minuteInterval(_ value: Int) -> Self {
        minuteInterval = value
        return self
    }
}


@available(iOS 13.4, *)
public extension UIDatePicker {

    func preferredDatePickerStyle(_ value: UIDatePickerStyle) -> Self {
        preferredDatePickerStyle = value
        return self
    }
}


@available(iOS 15.0, *)
public extension UIDatePicker {

    func roundsToMinuteInterval(_ value: Bool) -> Self {
        roundsToMinuteInterval = value
        return self
    }
}
