import UIKit


public extension UITextView {

    func delegate(_ value: UITextViewDelegate?) -> Self {
        delegate = value
        return self
    }

    func text(_ value: String?) -> Self {
        text = value
        return self
    }

    func font(_ value: UIFont?) -> Self {
        font = value
        return self
    }

    func textColor(_ value: UIColor?) -> Self {
        textColor = value
        return self
    }

    func textAlignment(_ value: NSTextAlignment) -> Self {
        textAlignment = value
        return self
    }

    func selectedRange(_ value: NSRange) -> Self {
        selectedRange = value
        return self
    }

    func editable(_ value: Bool) -> Self {
        isEditable = value
        return self
    }

    func selectable(_ value: Bool) -> Self {
        isSelectable = value
        return self
    }

    func dataDetectorTypes(_ value: UIDataDetectorTypes) -> Self {
        dataDetectorTypes = value
        return self
    }

    func allowsEditingTextAttributes(_ value: Bool) -> Self {
        allowsEditingTextAttributes = value
        return self
    }

    func attributedText(_ value: NSAttributedString!) -> Self {
        attributedText = value
        return self
    }

    func typingAttributes(_ value: [NSAttributedString.Key : Any]) -> Self {
        typingAttributes = value
        return self
    }

    func inputView(_ value: UIView?) -> Self {
        inputView = value
        return self
    }

    func inputAccessoryView(_ value: UIView?) -> Self {
        inputAccessoryView = value
        return self
    }

    func clearsOnInsertion(_ value: Bool) -> Self {
        clearsOnInsertion = value
        return self
    }

    func textContainerInset(_ value: UIEdgeInsets) -> Self {
        textContainerInset = value
        return self
    }

    func linkTextAttributes(_ value: [NSAttributedString.Key : Any]!) -> Self {
        linkTextAttributes = value
        return self
    }

    func usesStandardTextScaling(_ value: Bool) -> Self {
        usesStandardTextScaling = value
        return self
    }
}


// MARK: - Optional UITextInput

extension UITextView {

    func selectionAffinity(_ value : UITextStorageDirection) -> Self {
        selectionAffinity = value
        return self
    }
}


// MARK: - Optional UITextInputTraits

public extension UITextView {

    func autocapitalizationType(_ value: UITextAutocapitalizationType) -> Self {
        autocapitalizationType = value
        return self
    }

    func autocorrectionType(_ value: UITextAutocorrectionType) -> Self {
        autocorrectionType = value
        return self
    }

    func spellCheckingType(_ value: UITextSpellCheckingType) -> Self {
        spellCheckingType = value
        return self
    }

    func smartQuotesType(_ value: UITextSmartQuotesType) -> Self {
        smartQuotesType = value
        return self
    }

    func smartDashesType(_ value: UITextSmartDashesType) -> Self {
        smartDashesType = value
        return self
    }

    func smartInsertDeleteType(_ value: UITextSmartInsertDeleteType) -> Self {
        smartInsertDeleteType = value
        return self
    }

    func keyboardType(_ value: UIKeyboardType) -> Self {
        keyboardType = value
        return self
    }

    func keyboardAppearance(_ value: UIKeyboardAppearance) -> Self {
        keyboardAppearance = value
        return self
    }

    func returnKeyType(_ value: UIReturnKeyType) -> Self {
        returnKeyType = value
        return self
    }

    func enablesReturnKeyAutomatically(_ value: Bool) -> Self {
        enablesReturnKeyAutomatically = value
        return self
    }

    func isSecureTextEntry(_ value: Bool) -> Self {
        isSecureTextEntry = value
        return self
    }

    func textContentType(_ value: UITextContentType!) -> Self {
        textContentType = value
        return self
    }

    func passwordRules(_ value: UITextInputPasswordRules?) -> Self {
        passwordRules = value
        return self
    }
}
