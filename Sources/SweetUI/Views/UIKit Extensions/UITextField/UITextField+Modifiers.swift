import UIKit


public extension UITextField {

    func text(_ value: String?) -> Self {
        text = value
        return self
    }

    func attributedText(_ value: NSAttributedString?) -> Self {
        attributedText = value
        return self
    }

    func textColor(_ value: UIColor?) -> Self {
        textColor = value
        return self
    }

    func font(_ value: UIFont?) -> Self {
        font = value
        return self
    }

    func textAlignment(_ value: NSTextAlignment) -> Self {
        textAlignment = value
        return self
    }

    func borderStyle(_ value: UITextField.BorderStyle) -> Self {
        borderStyle = value
        return self
    }

    func defaultTextAttributes(_ value: [NSAttributedString.Key : Any]) -> Self {
        defaultTextAttributes = value
        return self
    }

    func placeholder(_ value: String?) -> Self {
        placeholder = value
        return self
    }

    func attributedPlaceholder(_ value: NSAttributedString?) -> Self {
        attributedPlaceholder = value
        return self
    }

    func clearsOnBeginEditing(_ value: Bool) -> Self {
        clearsOnBeginEditing = value
        return self
    }

    func adjustsFontSizeToFitWidth(_ value: Bool) -> Self {
        adjustsFontSizeToFitWidth = value
        return self
    }

    func minimumFontSize(_ value: CGFloat) -> Self {
        minimumFontSize = value
        return self
    }

    func background(_ value: UIImage?) -> Self {
        background = value
        return self
    }

    func disabledBackground(_ value: UIImage?) -> Self {
        disabledBackground = value
        return self
    }

    func allowsEditingTextAttributes(_ value: Bool) -> Self {
        allowsEditingTextAttributes = value
        return self
    }

    func typingAttributes(_ value: [NSAttributedString.Key : Any]?) -> Self {
        typingAttributes = value
        return self
    }

    func clearButtonMode(_ value: UITextField.ViewMode) -> Self {
        clearButtonMode = value
        return self
    }

    func leftView(_ value: UIView?) -> Self {
        leftView = value
        return self
    }

    func leftViewMode(_ value: UITextField.ViewMode) -> Self {
        leftViewMode = value
        return self
    }

    func rightView(_ value: UIView?) -> Self {
        rightView = value
        return self
    }

    func rightViewMode(_ value: UITextField.ViewMode) -> Self {
        rightViewMode = value
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
}


// MARK: - iOS 15.0

@available(iOS 15.0, *)
public extension UITextField {

    func interactionState(_ value: Any) -> Self {
        interactionState = value
        return self
    }
}


// MARK: - Optional UITextInput

extension UITextField {

    func selectionAffinity(_ value : UITextStorageDirection) -> Self {
        selectionAffinity = value
        return self
    }
}


// MARK: - Optional UITextInputTraits

public extension UITextField {

    func delegate(_ value: UITextFieldDelegate) -> Self {
        delegate = value
        return self
    }

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
