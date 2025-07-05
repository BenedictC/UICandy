import UIKit


// MARK: - UIControl additions

public protocol SomeControl: UIControl { }
extension UIControl: SomeControl { }

public struct BindingOption: OptionSet {

    public static let ignoreChangesWhileFirstResponder = Self(rawValue: 1 << 0)
    public static let `default`: BindingOption = []


    public var rawValue: UInt

    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
}

public extension SomeControl {

    func update<T>(_ keyPath: ReferenceWritableKeyPath<Self, T>, from viewState: ViewState<T>, options: BindingOption = .default) -> Self {
        let eventObserver = ControlEventObserver()
        eventObserver.updateStateHandler = { [weak viewState, unowned self] in
            let value = self[keyPath: keyPath]
            viewState?.setValue(value)
        }

        self.addTarget(eventObserver, action: #selector(ControlEventObserver.updateState), for: .editingChanged)
        self.onChanged(of: viewState, perform: { (control, value: T) in
            _ = eventObserver // Capture eventObserver
            let oldValue: T = self[keyPath: keyPath]
            let shouldIgnore = (options.contains(.ignoreChangesWhileFirstResponder) && control.isFirstResponder) || areEqual(value, oldValue)
            if !shouldIgnore {
                control[keyPath: keyPath] = value
            }
        })
        return self
    }
}


// MARK: - Dynamic equality checking

func areEqual(_ value: Any, _ otherValue: Any) -> Bool {
    if let value = value as? any Equatable,
       let otherValue = otherValue as? any Equatable {
        return value.isEqual(otherValue)
    }
    return false
}

private extension Equatable {

    func isEqual(_ other: any Equatable) -> Bool {
        guard let other = other as? Self else {
            return false
        }
        return self == other
    }
}


// MARK: - ControlEventObserver

class ControlEventObserver: NSObject {

    var updateStateHandler: (() -> Void)?

    @objc
    func updateState() {
        updateStateHandler?()
    }
}
