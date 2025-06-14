import UIKit
import Combine


// MARK: - Text

public extension UILabel {
    
    convenience init(text publisher: some Publisher<String, Never>) {
        self.init()
        // HACK ALERT! This causes a runtime crash due to a compiler bug related to the keyPath:
        // _ = self.assign(to: \.text, from: publisher, cancellableStorageProvider: cancellableStorageProvider)
        // So we have to do it the long way:
        publisher.sink { [weak self] value in
            self?.text = value
        }
        .store(in: CancellableStorage.current)
    }
    
    convenience init(text publisher: some Publisher<String?, Never>) {
        self.init()
        // HACK ALERT! This causes a runtime crash due to a compiler bug related to the keyPath:
        // _ = self.assign(to: \.text, from: publisher, cancellableStorageProvider: cancellableStorageProvider)
        // So we have to do it the long way:
        publisher.sink { [weak self] value in
            self?.text = value
        }
        .store(in: CancellableStorage.current)
    }
    
    func text(_ publisher: some Publisher<String, Never>) -> Self {
        // HACK ALERT! This causes a runtime crash due to a compiler bug related to the keyPath:
        // _ = self.assign(to: \.text, from: publisher, cancellableStorageProvider: cancellableStorageProvider)
        // So we have to do it the long way:
        publisher.sink { [weak self] value in
            self?.text = value
        }
        .store(in: CancellableStorage.current)
        return self
    }
    
    func text(_ publisher: some Publisher<String?, Never>) -> Self {
        // HACK ALERT! This causes a runtime crash due to a compiler bug related to the keyPath:
        // _ = self.assign(to: \.text, from: publisher, cancellableStorageProvider: cancellableStorageProvider)
        // So we have to do it the long way:
        publisher.sink { [weak self] value in
            self?.text = value
        }
        .store(in: CancellableStorage.current)
        return self
    }
}


// MARK: - AttributedText

public extension UILabel {
    
    convenience init(attributedText publisher: some Publisher<NSAttributedString, Never>) {
        self.init()
        // HACK ALERT! This causes a runtime crash due to a compiler bug related to the keyPath:
        // _ = self.assign(to: \.attributedText, from: publisher, cancellableStorageProvider: cancellableStorageProvider)
        // So we have to do it the long way:
        publisher.sink { [weak self] value in
            self?.attributedText = value
        }
        .store(in: CancellableStorage.current)
    }
    
    convenience init(attributedText publisher: some Publisher<NSAttributedString?, Never>) {
        self.init()
        // HACK ALERT! This causes a runtime crash due to a compiler bug related to the keyPath:
        //_ = self.assign(to: \.attributedText, from: publisher, cancellableStorageProvider: cancellableStorageProvider)
        // So we have to do it the long way:
        publisher.sink { [weak self] value in
            self?.attributedText = value
        }
        .store(in: CancellableStorage.current)
    }
    
    func attributedText(_ publisher: some Publisher<NSAttributedString, Never>) -> Self {
        // HACK ALERT! This causes a runtime crash due to a compiler bug related to the keyPath:
        // _ = self.assign(to: \.attributedText, from: publisher, cancellableStorageProvider: cancellableStorageProvider)
        // So we have to do it the long way:
        publisher.sink { [weak self] value in
            self?.attributedText = value
        }
        .store(in: CancellableStorage.current)
        return self
    }

    func attributedText(_ publisher: some Publisher<NSAttributedString?, Never>) -> Self {
        // HACK ALERT! This causes a runtime crash due to a compiler bug related to the keyPath:
        // _ = self.assign(to: \.attributedText, from: publisher, cancellableStorageProvider: cancellableStorageProvider)
        // So we have to do it the long way:
        publisher.sink { [weak self] value in
            self?.attributedText = value
        }        
        .store(in: CancellableStorage.current)
        return self
    }
}
