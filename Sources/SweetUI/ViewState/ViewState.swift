import UIKit


// MARK: - ViewState

@propertyWrapper
public final class ViewState<Value>: ReadOnlyViewState<Value> {

    // MARK: Types

    public typealias Value = Value


    // MARK: Properties

    public var projectedValue: ViewState<Value> { self }

    public override var value: Value {
        get { _value }
        set { _value = newValue }
    }

    @available(*, unavailable, message: "@ViewState is only available on instances of ViewStateUpdating")
    public var wrappedValue: Value {
        get { _value }
        set { _value = newValue }
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
            warnOfSuboptimalImplementationIfNeeded(object: host)
            viewState.value = newValue
        }
    }

    private var _value: Value {
        didSet { setHostsNeedUpdate() }
    }


    // MARK: Instance life cycle

    public init(wrappedValue: Value) {
        self._value = wrappedValue
        super.init(getter: nil)
        self.getter = { [unowned self] in self._value }
    }


    // MARK: Debug

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

public class ReadOnlyViewState<Value>: BaseViewState {

    typealias Getter = () -> Value

    var value: Value { getter() }
    var getter: Getter!


    init(getter: Getter?) {
        self.getter = getter
    }
}


// MARK: - BaseViewState

public class BaseViewState {

    struct HostWrapper {
        weak var host: ViewStateHosting?
    }

    private var hostWrappers = [HostWrapper]()

    public func addHost(_ host: ViewStateHosting) {
        let wrapper = HostWrapper(host: host)
        hostWrappers.append(wrapper)
    }

    public func removeHost(_ host: ViewStateHosting) {
        hostWrappers = hostWrappers.filter { $0.host != nil && $0.host !== host }
    }

    func setHostsNeedUpdate() {
        for wrapper in hostWrappers {
            wrapper.host?.setViewStateDidChange()
        }
    }
}
