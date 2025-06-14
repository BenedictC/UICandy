import UIKit
import Combine


public extension UIBarButtonItem {

    func width(_ publisher: some Publisher<CGFloat, Never>) -> Self {
        // HACK ALERT! This causes a runtime crash due to a compiler bug related to the keyPath:
        // assign(to: \.isHidden, from: publisher, cancellableStorageProvider: cancellableStorageProvider)
        // So we have to do it the long way:
        publisher.sink { [weak self] value in
            self?.width = value
        }
        .store(in: .current)
        return self
    }
}


@available(iOS 14, *)
public extension UIBarButtonItem {

    func menu(_ publisher: some Publisher<UIMenu?, Never>) -> Self {
        // HACK ALERT! This causes a runtime crash due to a compiler bug related to the keyPath:
        // assign(to: \.isHidden, from: publisher, cancellableStorageProvider: cancellableStorageProvider)
        // So we have to do it the long way:
        publisher.sink { [weak self] value in
            _ = self?.menu(value)
        }
        .store(in: .current)
        return self
    }
}


@available(iOS 15, *)
public extension UIBarButtonItem {

    func selected(_ publisher: some Publisher<Bool, Never>) -> Self {
        // HACK ALERT! This causes a runtime crash due to a compiler bug related to the keyPath:
        // assign(to: \.isHidden, from: publisher, cancellableStorageProvider: cancellableStorageProvider)
        // So we have to do it the long way:
        publisher.sink { [weak self] value in
            self?.isSelected = value
        }
        .store(in: .current)        
        return self
    }
}


@available(iOS 16, *)
public extension UIBarButtonItem {

    func hidden(_ publisher: some Publisher<Bool, Never>) -> Self {
        // HACK ALERT! This causes a runtime crash due to a compiler bug related to the keyPath:
        // assign(to: \.isHidden, from: publisher, cancellableStorageProvider: cancellableStorageProvider)
        // So we have to do it the long way:
        publisher.sink { [weak self] value in
            self?.isHidden = value
        }
        .store(in: .current)        
        return self
    }
}


// MARK: - isSelected

@available(iOS 15, *)
public extension UIBarButtonItem {

    // MARK: Types

    private class BarButtonItemIsSelectedToggler: NSObject {

        static let shared = BarButtonItemIsSelectedToggler()

        private let subjectsByItem = NSMapTable<UIBarButtonItem, AnySubject<Bool, Never>>.weakToStrongObjects()

        func registerSubject(_ subject: some Subject<Bool, Never>, for item: UIBarButtonItem) {
            item.target = self
            item.action = #selector(BarButtonItemIsSelectedToggler.toggle(_:))
            let anySubject = subject.eraseToAnySubject()
            subjectsByItem.setObject(anySubject, forKey: item)
        }

        private func subject(for item: UIBarButtonItem) -> AnySubject<Bool, Never>? {
            subjectsByItem.object(forKey: item)
        }

        @objc
        func toggle(_ sender: AnyObject) {
            guard let barButtonItem = sender as? UIBarButtonItem else { return }
            let subject = subject(for: barButtonItem)
            subject?.send(!barButtonItem.isSelected)
        }
    }

    // # image:

    convenience init(
        title: String? = nil,
        image: UIImage,
        style: UIBarButtonItem.Style = .plain,
        selected subject: some Subject<Bool, Never>
    ) {
        self.init(title: title, image: image, primaryAction: nil)
        self.style = style

        BarButtonItemIsSelectedToggler.shared.registerSubject(subject, for: self)
        subject.sink { [weak self] newValue in
            self?.isSelected = newValue
        }
        .store(in: .current)
    }


    // # imageName:

    convenience init(
        title: String? = nil,
        imageName: String,
        style: UIBarButtonItem.Style = .plain,
        selected subject: some Subject<Bool, Never>
    ) {
        let image = UIImage(named: imageName)
        self.init(title: title, image: image, primaryAction: nil)
        self.style = style

        BarButtonItemIsSelectedToggler.shared.registerSubject(subject, for: self)
        subject.sink { [weak self] newValue in
            self?.isSelected = newValue
        }
        .store(in: .current)

    }


    // # systemImageName:

    convenience init(
        title: String? = nil,
        systemImageName: String,
        style: UIBarButtonItem.Style = .plain,
        selected subject: some Subject<Bool, Never>
    ) {
        let image = UIImage(systemName: systemImageName)
        self.init(title: title, image: image, primaryAction: nil)
        self.style = style

        BarButtonItemIsSelectedToggler.shared.registerSubject(subject, for: self)
        subject.sink { [weak self] newValue in
            self?.isSelected = newValue
        }
        .store(in: .current)
    }
}
