import UIKit


@propertyWrapper
public final class ViewState<Value>: ReadOnlyViewState<Value>, AnyViewState {

    // MARK: Types

    public typealias Value = Value


    // MARK: Properties

    @available(*, unavailable, message: "@ViewState is only available on instances of ViewStateUpdating")
    public var wrappedValue: Value {
        get { _value }
        set { _value = newValue }
    }

    public var projectedValue: ViewState<Value> { self }
    //public private(set) lazy var target = ViewStateTarget(viewState: self)

    private var _value: Value {
        didSet { host?.setViewStateDidChange() }
    }
    weak var host: ViewStateHosting? {
        didSet { flushObservationsAwaitingRegistration() }
    }

    private var observationsAwaitingRegistration = [ViewStateObservation]()
    

    public static subscript<EnclosingObject: ViewStateHosting>(
        _enclosingInstance object: EnclosingObject,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingObject, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingObject, ViewState<Value>>
    ) -> Value {
        get {
            // Store the enclosing object so it can be referenced by the target if used
            let storage = object[keyPath: storageKeyPath]
            storage.host = object

            return storage._value
        }
        set {
            // Store the enclosing object so it can be referenced by the target if used
            let storage = object[keyPath: storageKeyPath]
            storage.host = object

            warnOfSuboptimalImplementationIfNeeded(object: object)
            storage._value = newValue
        }
    }

    public init(wrappedValue: Value) {
        self._value = wrappedValue
        super.init()
        self.getter = { [unowned self] in self._value }
        self.registerViewStateObservationProvider = { [unowned self] in self.host?.registerViewStateObservation($0) }
    }

    override func registerViewStateObservation(_ observation: ViewStateObservation) {
        observationsAwaitingRegistration.append(observation)
        flushObservationsAwaitingRegistration()
    }

    func flushObservationsAwaitingRegistration() {
        guard let host = projectedValue.host else { return }
        for observation in observationsAwaitingRegistration {
            host.registerViewStateObservation(observation)
        }
        observationsAwaitingRegistration = []
    }

    func setValue(_ newValue: Value) {
        _value = newValue
    }

    private static func warnOfSuboptimalImplementationIfNeeded(object: ViewStateHosting) {
        let illBehavingMethodName: String
        if object is UIView, threadContainsSymbol(matching: { $0.contains("layoutSubviews") }) {
            illBehavingMethodName = "layoutSubviews()"
        } else
        if object is UIViewController, threadContainsSymbol(matching: { $0.contains("viewWillLayoutSubviews") }) {
            illBehavingMethodName = "viewWillLayoutSubviews()"
        } else {
            return
        }

        let message = "ViewState is being modified during \(illBehavingMethodName) of \(object)."
        + " This will cause excessive layout passes."
        runtimeWarn(message)
    }

    static func threadContainsSymbol(matching predicate: (String) -> Bool) -> Bool {
        Thread.callStackSymbols.contains(where: predicate)
    }
}


// MARK: - ReadOnlyViewState

public class ReadOnlyViewState<Value>: _AnyViewState {

    typealias RegisterViewStateObservationProvider = (ViewStateObservation) -> Void

    var value: Value { getter() }

    var getter: (() -> Value)!
    var registerViewStateObservationProvider: RegisterViewStateObservationProvider!

    init() {

    }

    init(getter: @escaping () -> Value, registerViewStateObservationProvider: @escaping RegisterViewStateObservationProvider) {
        self.getter = getter
        self.registerViewStateObservationProvider = registerViewStateObservationProvider
    }

    @available(*, deprecated, message: "Use addViewStateObservation instead.")
    func registerViewStateObservation(_ observation: ViewStateObservation) {
        registerViewStateObservationProvider(observation)
    }

    public func addViewStateObservation<T: UIView>(identifier: AnyHashable?, withView view: T, handler: @escaping (T, ReadOnlyViewState<Value>) -> Void) {
        let observation = ViewStateObservation(identifier: identifier, updateHandler: { [weak view, weak self] in
            guard let view, let self else { return false }
            handler(view, self)
            return true
        })
        registerViewStateObservationProvider(observation)
    }

    public func addViewStateObservation<T: UIView>(identifier: AnyHashable?, withView view: T, keyPath: ReferenceWritableKeyPath<T, Value>) {
        let observation = ViewStateObservation(identifier: identifier, updateHandler: { [weak view, weak self] in
            guard let view, let self else { return false }
            view[keyPath: keyPath] = self.value
            return true
        })
        registerViewStateObservationProvider(observation)
    }
}


// MARK: Mapping

public extension ReadOnlyViewState {

    func map<T>(_ transform: @escaping (Value) -> T) -> ReadOnlyViewState<T> {
        let getter = self.getter!
        return ReadOnlyViewState<T>(
            getter: { transform(getter()) },
            registerViewStateObservationProvider: self.registerViewStateObservationProvider
        )
    }
}


public extension ReadOnlyViewState where Value == Bool {

    var negate: ReadOnlyViewState<Bool> { map { !$0 } }
}


public protocol _Optionable {

    associatedtype Wrapped
    var _asOptional: Wrapped? { get }
}

extension Optional: _Optionable {

    public var _asOptional: Wrapped? { self }
}

public extension ReadOnlyViewState where Value: _Optionable {

    var isNil: ReadOnlyViewState<Bool> { map { $0._asOptional == nil } }
    var isNotNil: ReadOnlyViewState<Bool> { map { $0._asOptional != nil } }
}


// MARK: - AnyViewState

protocol AnyViewState: _AnyViewState {

    var host: ViewStateHosting? { get set }
}


public protocol _AnyViewState: AnyObject {

}
