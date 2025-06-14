import UIKit
import Combine


// MARK: - Modifiers

@MainActor
public extension SomeView where Self: UITextView {
    
    func text(
        bindsTo subject: some Subject<String?, Never>,
        options: UITextInputBindingOption
    )
    -> Self {
        subscribeAndSendText(to: subject, options: options).store(in: .current)
        return self
    }
    
    func attributedText(
        bindsTo subject: some Subject<NSAttributedString?, Never>,
        options: UITextInputBindingOption
    )
    -> Self {
        subscribeAndSendAttributedText(to: subject, options: options).store(in: .current)
        return self
    }
    
    func text(
        bindsTo subject: some Subject<String, Never>,
        options: UITextInputBindingOption
    )
    -> Self {
        subscribeAndSendText(to: subject, options: options).store(in: .current)
        return self
    }
    
    func attributedText(
        bindsTo subject: some Subject<NSAttributedString, Never>,
        options: UITextInputBindingOption
    )
    -> Self {
        subscribeAndSendAttributedText(to: subject, options: options).store(in: .current)
        return self
    }
}


// MARK: - Initializers

public extension UITextView {
    
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

private extension SomeView where Self: UITextView {
    
    func subscribeAndSendText(to subject: some Subject<String?, Never>, options: UITextInputBindingOption) -> AnyCancellable {
        return makeBindings(for: subject, options: options, keyPath: \.text)
    }
    
    func subscribeAndSendAttributedText(to subject: some Subject<NSAttributedString?, Never>, options: UITextInputBindingOption) -> AnyCancellable {
        makeBindings(for: subject, options: options, keyPath: \.attributedText)
    }
    
    func subscribeAndSendText(to subject: some Subject<String, Never>, options: UITextInputBindingOption) -> AnyCancellable {
        return makeBindings(for: subject, options: options, keyPath: \.text)
    }
    
    func subscribeAndSendAttributedText(to subject: some Subject<NSAttributedString, Never>, options: UITextInputBindingOption) -> AnyCancellable {
        makeBindings(for: subject, options: options, keyPath: \.attributedText)
    }
    
    func makeBindings<V>(for subject: some Subject<V, Never>, options: UITextInputBindingOption, keyPath: ReferenceWritableKeyPath<Self, V>) -> AnyCancellable {
        // TODO: Add support for begin & end editing synchronization behaviour
        let send = NotificationCenter.default.addObserver(forName: UITextView.textDidChangeNotification, object: self, queue: nil) { notification in
            guard let textView = notification.object as? Self  else {
                return
            }
            let value = textView[keyPath: keyPath]
            subject.send(value)
        }
        let receive = subject.sink { value in
            let shouldUpdate = !self.isFirstResponder || options.contains(.updatesTextWhenIsFirstResponder)
            guard shouldUpdate else { return }
            // TODO: Maintain cursor/selection when isFirstResponder
            self[keyPath: keyPath] = value
        }
        return AnyCancellable {
            NotificationCenter.default.removeObserver(send)
            receive.cancel()
        }
    }
}
