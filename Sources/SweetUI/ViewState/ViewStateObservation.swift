

public struct ViewStateObservation {

    public let identifier: AnyHashable?

    let updateHandler: () -> Bool

    func performUpdate() -> Bool {
        updateHandler()
    }
}

public extension SomeView {

    /// The update is triggered by the enclosingObject of the source.
    @discardableResult
    func onChanged<Value>(
        of viewState: ReadOnlyViewState<Value>,
        identifier: AnyHashable? = nil,
        perform onChangedHandler: @escaping (Self, Value) -> Void,
    ) -> Self {
        let observation = ViewStateObservation(identifier: identifier) { [weak self, weak viewState] in
            guard let self, let viewState else { return false }
            onChangedHandler(self, viewState.value)
            return true
        }
        viewState.registerViewStateObservation(observation)
        return self
    }
}


public extension SomeView {

    @discardableResult
    func assign<Value>(
        _ viewState: ReadOnlyViewState<Value>,
        to propertyKeyPath: ReferenceWritableKeyPath<Self, Value>,
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
    func assign<Value>(
        _ viewState: ReadOnlyViewState<Value>,
        to propertyKeyPath: ReferenceWritableKeyPath<Self, Value?>,
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
