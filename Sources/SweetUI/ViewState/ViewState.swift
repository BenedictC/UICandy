import UIKit


// MARK: - ViewState

@propertyWrapper
public final class ViewState<Value>: BaseViewState {

    // MARK: Types

    public typealias Value = Value


    // MARK: Properties

    public var projectedValue: ViewState<Value> { self }

    public var value: Value {
        didSet { notifyObserversOfViewStateChange() }
    }

    @available(*, unavailable, message: "@ViewState is only available on instances of ViewStateObserver")
    public var wrappedValue: Value {
        get { value }
        set { value = newValue }
    }

    public static subscript<EnclosingObject: ViewStateObserver>(
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

@MainActor
public class BaseViewState {

    // MARK: Types

    private struct ObserverWrapper: Hashable {

        weak var observer: ViewStateObserver?

        static func ==(lhs: ObserverWrapper, rhs: ObserverWrapper) -> Bool {
            lhs.observer === rhs.observer
        }

        func hash(into hasher: inout Hasher) {
            guard let observer else {
                hasher.combine(0)
                return
            }
            let id = ObjectIdentifier(observer)
            hasher.combine(id)
        }
    }


    // MARK: Properties

    private var wrappers = Set<ObserverWrapper>()


    // MARK: Host Management

    public func addObserver(_ observer: ViewStateObserver) {
        let wrapper = ObserverWrapper(observer: observer)
        wrappers.insert(wrapper)
    }

    public func removeObserver(_ host: ViewStateObserver) {
        wrappers = wrappers.filter { $0.observer != nil && $0.observer !== host }
    }

    func notifyObserversOfViewStateChange() {
        for wrapper in wrappers {
            wrapper.observer?.viewStateDidChange()
        }
    }
}
