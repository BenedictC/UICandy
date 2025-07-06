import UIKit


public extension UITextInput {

    func selectedTextRange(_ value : UITextRange?) -> Self {
        selectedTextRange = value
        return self
    }

    func markedTextStyle(_ value : [NSAttributedString.Key : Any]?) -> Self {
        markedTextStyle = value
        return self
    }

    func inputDelegate(_ value : UITextInputDelegate?) -> Self {
        inputDelegate = value
        return self
    }    

    func markedText(_ markedText: String?, selectedRange: NSRange) -> Self {
        setMarkedText(markedText, selectedRange: selectedRange)
        return self
    }

    func baseWritingDirection(_ writingDirection: NSWritingDirection, for range: UITextRange) -> Self {
        setBaseWritingDirection(writingDirection, for: range)
        return self
    }
}
