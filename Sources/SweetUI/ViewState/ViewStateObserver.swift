import UIKit


// MARK: - ViewStateObserver

public protocol ViewStateObserver: AnyObject {

    func initializeViewStateObserving()
    func viewStateDidChange()
}


// MARK: - Default implementations

public extension ViewStateObserver {

    func initializeViewStateObserving() {
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if let viewState = child.value as? BaseViewState {
                viewState.addObserver(self)
            }
        }
        viewStateDidChange()
    }
}


// MARK: - Debug

extension ViewStateObserver {

    func warnOfReentrantViewStatePropagation() {
        let message = "Object <\(self)> recursively called propagateViewState(). This may cause deadlocks."
        runtimeWarn(message)
    }
}


// MARK: - Standalone observation

public extension ViewState {

    func observe(withHandler handler: @escaping (Value) -> Void) -> ViewStateObservation {
        // Create observation
        let observation = ConcreteViewStateObservation()
        observation.handler = { [weak self] in
            guard let self else { return }
            handler(self.value)
        }
        self.addObserver(observation)

        // Fire initial value
        handler(value)

        return observation
    }
}


public class ViewStateObservation: Hashable {

    public func cancel() {
        // For concrete subclasses to override.
    }


    // MARK: Hashable

    public func hash(into hasher: inout Hasher) {
        let identifier = ObjectIdentifier(self)
        hasher.combine(identifier)
    }

    public static func == (lhs: ViewStateObservation, rhs: ViewStateObservation) -> Bool {
        lhs === rhs
    }


    // MARK: Storage

    public func store(in observations: inout Set<ViewStateObservation>) {
        observations.insert(self)
    }
}


private final class ConcreteViewStateObservation: ViewStateObservation, ViewStateObserver {

    // MARK: Properties

    var handler: (() -> Void)?


    // MARK: ViewStateObserver

    func viewStateDidChange() {
        handler?()
    }


    // MARK: ViewStateObservation

    override func cancel() {
        handler = nil
    }
}
