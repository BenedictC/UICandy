import UIKit


public extension SomeView {

    /// The update is triggered by the enclosingObject of the source.
    @discardableResult
    func onPropertyUpdate<Host: ViewStateHosting>(of host: Host,
        identifier: AnyHashable? = nil,
        perform onUpdateHandler: @escaping (Self, Host) -> Void,
    ) -> Self {
        let observation = ViewStateObservation(identifier: identifier) { [weak self, weak host] in
            guard let self, let host else { return false }
            onUpdateHandler(self, host)
            return true
        }
        host.registerViewStateObservation(observation)
        return self
    }
}


public extension SomeView {

    @discardableResult
    func update<Value>(
        _ propertyKeyPath: ReferenceWritableKeyPath<Self, Value>,
        from viewState: ReadOnlyViewState<Value>,
        identifier: AnyHashable? = nil
    ) -> Self {
        let observation = ViewStateObservation(identifier: identifier) { [weak self, weak viewState] in
            guard let self, let viewState else { return false }
            self[keyPath: propertyKeyPath] = viewState.value
            return true
        }
        viewState.registerViewStateObservation(observation)
        return self
    }

    @discardableResult
    func update<Value>(
        _ propertyKeyPath: ReferenceWritableKeyPath<Self, Value?>,
        from viewState: ReadOnlyViewState<Value>,
        identifier: AnyHashable? = nil
    ) -> Self {
        let observation = ViewStateObservation(identifier: identifier) { [weak self, weak viewState] in
            guard let self, let viewState else { return false }
            self[keyPath: propertyKeyPath] = viewState.value
            return true
        }
        viewState.registerViewStateObservation(observation)
        return self
    }
}
