import UIKit


// MARK: - ViewState

@propertyWrapper
public final class ViewState<Value>: BaseViewState {

    // MARK: Types

    public typealias Value = Value


    // MARK: Properties

    public var projectedValue: ViewState<Value> { self }

    public var value: Value {
        didSet { notifyHostsOfViewStateChange() }
    }

    @available(*, unavailable, message: "@ViewState is only available on instances of ViewStateHosting")
    public var wrappedValue: Value {
        get { value }
        set { value = newValue }
    }

    public static subscript<EnclosingObject: ViewStateHosting>(
        _enclosingInstance host: EnclosingObject,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingObject, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingObject, ViewState<Value>>
    ) -> Value {
        get {
            let viewState = host[keyPath: storageKeyPath]
            return viewState.value
        }
        set {
            let viewState = host[keyPath: storageKeyPath]
            viewState.value = newValue
        }
    }


    // MARK: Instance life cycle

    public init(wrappedValue: Value) {
        self.value = wrappedValue
        super.init()
    }
}


// MARK: - BaseViewState

public class BaseViewState {

    // MARK: Types

    private struct HostWrapper: Hashable {
        
        weak var host: ViewStateHosting?

        static func ==(lhs: HostWrapper, rhs: HostWrapper) -> Bool {
            lhs.host === rhs.host
        }

        func hash(into hasher: inout Hasher) {
            guard let host else {
                hasher.combine(0)
                return
            }
            let id = ObjectIdentifier(host)
            hasher.combine(id)
        }
    }


    // MARK: Properties

    private var hostWrappers = Set<HostWrapper>()


    // MARK: Host Management

    public func addHost(_ host: ViewStateHosting) {
        let wrapper = HostWrapper(host: host)
        hostWrappers.insert(wrapper)
    }

    public func removeHost(_ host: ViewStateHosting) {
        hostWrappers = hostWrappers.filter { $0.host != nil && $0.host !== host }
    }

    func notifyHostsOfViewStateChange() {
        for wrapper in hostWrappers {
            wrapper.host?.viewStateDidChange()
        }
    }
}


// MARK: - Observation

private class ViewStateObservation: NSObject, ViewStateHosting {

    var handler: (() -> Void)?

    func viewStateDidChange() {
        handler?()
    }
}


public extension ViewState {

    func observe(withHandler handler: @escaping (Value) -> Void) -> NSObjectProtocol {
        // Create observation
        let observation = ViewStateObservation()
        observation.handler = { [weak self] in
            guard let self else { return }
            handler(self.value)
        }
        self.addHost(observation)

        // Fire initial value
        handler(value)

        return observation
    }
}
