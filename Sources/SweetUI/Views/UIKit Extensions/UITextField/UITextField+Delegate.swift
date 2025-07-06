import UIKit


// MARK: - End editing on return

public extension UITextField {

    func delegateWithReturnAction(next: UIResponder) -> Self {
        let delegate = TextFieldKeyboardDelegate.shared
        let action = TextFieldKeyboardDelegate.Action(handler: { [weak next] _ in next?.becomeFirstResponder() })
        delegate.setAction(action, for: self)
        self.delegate = delegate
        return self
    }

    func delegateWithReturnAction(_ handler: @escaping (() -> Void)) -> Self {
        let delegate = TextFieldKeyboardDelegate.shared
        let action = TextFieldKeyboardDelegate.Action(handler: { _ in
            handler()
        })
        delegate.setAction(action, for: self)
        self.delegate = delegate
        return self
    }

    func delegateWithReturnAction(_ handler: @escaping ((Self) -> Void)) -> Self {
        let delegate = TextFieldKeyboardDelegate.shared
        let action = TextFieldKeyboardDelegate.Action { [weak self] _ in
            guard let self = self else {
                return
            }
            handler(self)
        }
        delegate.setAction(action, for: self)
        self.delegate = delegate
        return self
    }
}


public extension SomeView where Self: UITextField {

    func delegateWithReturnAction( 
        with action: @escaping (Self) -> Void)
    -> Self {
        let delegate = TextFieldKeyboardDelegate.shared
        let delegateAction = TextFieldKeyboardDelegate.Action { textField in
            guard let textField = textField as? Self else { return }
            action(textField)
        }
        delegate.setAction(delegateAction, for: self)
        self.delegate = delegate
        return self
    }
}


// MARK: - 

private final class TextFieldKeyboardDelegate: NSObject, UITextFieldDelegate {

    class Action {

        let handler: (UITextField) -> Void

        init?(handler: ((UITextField) -> Void)?) {
            guard let handler = handler else {
                return nil
            }
            self.handler = handler
        }

        func execute(with textField: UITextField) {
            handler(textField)
        }
    }


    static let shared = TextFieldKeyboardDelegate()

    let actions = NSMapTable<UITextField, Action>.weakToStrongObjects()

    func setAction(_ action: Action?, for textField: UITextField) {
        guard let action = action else {
            actions.removeObject(forKey: textField)
            return
        }
        actions.setObject(action, forKey: textField)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let action = actions.object(forKey: textField)
        action?.execute(with: textField)
        return false
    }
}
