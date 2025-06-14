import UIKit
import Combine


// MARK: - CancellablesStorageProvider

public extension UISwitch {
    
    convenience init(isOn subject: some Subject<Bool, Never>) {
        self.init()
        _ = self.isOn(bindsTo: subject)
    }
}


@MainActor
public extension SomeView where Self: UISwitch {
    
    func isOn(bindsTo subject: some Subject<Bool, Never>) -> Self {
        subscribeAndSendIsOn(to: subject).store(in: .current)
        return self
    }
}


// MARK: - Core

private extension UISwitch {
    
    func subscribeAndSendIsOn(to subject: some Subject<Bool, Never>) -> AnyCancellable {
        return SwitchIsOnToggler.shared.bindIsOn(of: self, to: subject)
    }
}


// MARK: - ButtonIsSelectedToggler

// This class could be generalised but it would get even more complicated.
private class SwitchIsOnToggler: NSObject {
    
    static let shared = SwitchIsOnToggler()
    
    private var subjectsByButton = NSMapTable<UISwitch, NSMutableSet>.weakToStrongObjects()
    
    private func subjects(for button: UISwitch) -> NSMutableSet {
        if let existing = subjectsByButton.object(forKey: button) {
            return existing
        }
        let subjects = NSMutableSet()
        subjectsByButton.setObject(subjects, forKey: button)
        return subjects
    }
    
    func bindIsOn(of button: UISwitch, to subject: some Subject<Bool, Never>) -> AnyCancellable {
        let anySubject = subject.eraseToAnySubject()
        // Store the subject
        subjects(for: button).add(anySubject)
        
        // Add the target
        button.addTarget(self, action: #selector(toggle(_:)), for: .primaryActionTriggered)
        let sendCancellable = AnyCancellable {
            button.removeTarget(self, action: #selector(self.toggle(_:)), for: .primaryActionTriggered)
        }
        let receiveCancellable = anySubject.sink {
            if button.isOn != $0 {
                button.isOn = $0
            }
        }
        
        return AnyCancellable {
            [sendCancellable, receiveCancellable].forEach { $0.cancel() }
        }
    }
    
    @objc
    private func toggle(_ sender: Any?) {
        guard let button = sender as? UISwitch else {
            return
        }
        
        let newValue = button.isOn
        subjects(for: button)
            .compactMap { $0 as? AnySubject<Bool, Never> }
            .forEach { $0.send(newValue) }
    }
}
