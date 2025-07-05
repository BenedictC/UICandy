import UIKit


public extension UIControl {
    
    func updateIsEnabled(from viewState: ReadOnlyViewState<Bool>, identifier: AnyHashable? = nil) -> Self {
        viewState.addViewStateObservation(identifier: identifier, withView: self, keyPath: \.isEnabled)
        return self
    }

    func updateIsSelected(from viewState: ReadOnlyViewState<Bool>, identifier: AnyHashable? = nil) -> Self {
        viewState.addViewStateObservation(identifier: identifier, withView: self, keyPath: \.isSelected)
        return self
    }

    func updateIsHighlighted(from viewState: ReadOnlyViewState<Bool>, identifier: AnyHashable? = nil) -> Self {
        viewState.addViewStateObservation(identifier: identifier, withView: self, keyPath: \.isHighlighted)
        return self
    }
}
