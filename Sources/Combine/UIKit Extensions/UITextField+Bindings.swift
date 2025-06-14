import UIKit
import Combine

// TODO: Add variants for non-optional subjects (String? & NSAttributedString?)


// MARK: - Init

@MainActor
public extension SomeView where Self: UITextField {
    
    func text(
        bindsTo subject: some Subject<String?, Never>,
        options: UITextInputBindingOption = []
    ) -> Self {
        bindText(to: subject, options: options).store(in: .current)
        return self
    }
    
    func attributedText(
        bindsTo subject: some Subject<NSAttributedString?, Never>,
        options: UITextInputBindingOption = []
    ) -> Self {
        bindAttributedText(to: subject, options: options).store(in: .current)
        return self
    }
    
    func text(
        bindsTo subject: some Subject<String, Never>,
        options: UITextInputBindingOption = []
    ) -> Self {
        bindText(to: subject, options: options).store(in: .current)
        return self
    }
    
    func attributedText(
        bindsTo subject: some Subject<NSAttributedString, Never>,
        options: UITextInputBindingOption = []
    ) -> Self {
        bindAttributedText(to: subject, options: options).store(in: .current)
        return self
    }
}


// MARK: - Initializers

public extension UITextField {
    
    convenience init(
        text subject: some Subject<String?, Never>,
        options: UITextInputBindingOption = []
    ) {
        self.init()
        _ = self.text(bindsTo: subject, options: options)
    }
    
    convenience init(
        text subject: some Subject<NSAttributedString?, Never>,
        options: UITextInputBindingOption = []
    ) {
        self.init()
        _ = self.attributedText(bindsTo: subject, options: options)
    }
    
    convenience init(
        text subject: some Subject<String, Never>,
        options: UITextInputBindingOption = []
    ) {
        self.init()
        _ = self.text(bindsTo: subject, options: options)
    }
    
    convenience init(
        text subject: some Subject<NSAttributedString, Never>,
        options: UITextInputBindingOption = []
    ) {
        self.init()
        _ = self.attributedText(bindsTo: subject, options: options)
    }
}


// MARK: - Core binding creation

private extension SomeView where Self: UITextField {
    
    func bindText(to subject: some Subject<String?, Never>, options: UITextInputBindingOption = []) -> AnyCancellable {
        return makeBindings(for: subject, keyPath: \.text, options: options)
    }
    
    func bindAttributedText(to subject: some Subject<NSAttributedString?, Never>, options: UITextInputBindingOption = []) -> AnyCancellable {
        makeBindings(for: subject, keyPath: \.attributedText, options: options)
    }
    
    func bindText(to subject: some Subject<String, Never>, options: UITextInputBindingOption = []) -> AnyCancellable {
        return makeBindings(for: subject, keyPath: \.text, defaultValue: "", options: options)
    }
    
    func bindAttributedText(to subject: some Subject<NSAttributedString, Never>, options: UITextInputBindingOption = []) -> AnyCancellable {
        makeBindings(for: subject, keyPath: \.attributedText, defaultValue: NSAttributedString(string: ""), options: options)
    }
}


private extension SomeView where Self: UITextField {
    
    func makeBindings<V>(
        for subject: some Subject<V, Never>,
        keyPath: ReferenceWritableKeyPath<Self, V>, options: UITextInputBindingOption
    ) -> AnyCancellable {
        let send = self.addAction(for: .editingChanged) { textField, _ in
            subject.send(textField[keyPath: keyPath])
        }
        let editingDidEnd = self.addAction(for: [.editingDidEnd]) { textField, event in
            // Changes from the subject are ignore while the textField has focus so
            // resynchronize the value when editing ends.
            _ = subject.sink { textField[keyPath: keyPath] = $0 }
        }
        let receive = subject.sink { [weak self] value in
            guard let self = self else { return }
            let shouldUpdate = !self.isFirstResponder || options.contains(.updatesTextWhenIsFirstResponder)
            guard shouldUpdate else { return }
            self[keyPath: keyPath] = value
        }
        return AnyCancellable {
            editingDidEnd.cancel()
            send.cancel()
            receive.cancel()
        }
    }
    
    func makeBindings<V>(
        for subject: some Subject<V, Never>,
        keyPath: ReferenceWritableKeyPath<Self, V?>,
        defaultValue: V,
        options: UITextInputBindingOption
    ) -> AnyCancellable {
        let send = self.addAction(for: .editingChanged) { textField, _ in
            subject.send(textField[keyPath: keyPath] ?? defaultValue)
        }
        let editingDidEnd = self.addAction(for: [.editingDidEnd]) { textField, event in
            // Changes from the subject are ignore while the textField has focus so
            // resynchronize the value when editing ends.
            _ = subject.sink { textField[keyPath: keyPath] = $0 }
        }
        let receive = subject.sink { [weak self] value in
            guard let self = self else { return }
            let shouldUpdate = !self.isFirstResponder || options.contains(.updatesTextWhenIsFirstResponder)
            guard shouldUpdate else { return }
            self[keyPath: keyPath] = value
        }
        return AnyCancellable {
            editingDidEnd.cancel()
            send.cancel()
            receive.cancel()
        }
    }
}
