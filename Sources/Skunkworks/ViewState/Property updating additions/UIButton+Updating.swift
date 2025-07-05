import UIKit


// MARK: - Title

@MainActor
public extension SomeView where Self: UIButton {
    
    func updateTitle(state: UIControl.State = .normal, from viewState: ReadOnlyViewState<String?>, identifier: AnyHashable? = nil) -> Self {
        viewState.addViewStateObservation(identifier: identifier, withView: self, handler: {
            $0.setTitle($1.value, for: state)
        })
        return self
    }

    func updateTitle(state: UIControl.State = .normal, from viewState: ReadOnlyViewState<String>, identifier: AnyHashable? = nil) -> Self {
        viewState.addViewStateObservation(identifier: identifier, withView: self, handler: {
            $0.setTitle($1.value, for: state)
        })
        return self
    }
}


// MARK: - Selected

@MainActor
public extension SomeView where Self: UIButton {
    
    func updateIsSelected(from viewState: ReadOnlyViewState<Bool>, identifier: AnyHashable? = nil) -> Self {
        viewState.addViewStateObservation(identifier: identifier, withView: self, keyPath: \.isSelected)
        return self
    }
}
