import UIKit


public extension UIView {

    func updateIsHidden(from viewState: ReadOnlyViewState<Bool>, identifier: AnyHashable? = nil) -> Self {
        viewState.addViewStateObservation(identifier: identifier, withView: self, keyPath: \.isHidden)
        return self
    }

    func updateAlpha(from viewState: ReadOnlyViewState<CGFloat>, identifier: AnyHashable? = nil) -> Self {
        viewState.addViewStateObservation(identifier: identifier, withView: self, keyPath: \.alpha)
        return self
    }

    func updateBackgroundColor(from viewState: ReadOnlyViewState<UIColor?>, identifier: AnyHashable? = nil) -> Self {
        viewState.addViewStateObservation(identifier: identifier, withView: self, keyPath: \.backgroundColor)
        return self
    }

    func updateBackgroundColor(from viewState: ReadOnlyViewState<UIColor>, identifier: AnyHashable? = nil) -> Self {
        viewState.addViewStateObservation(identifier: identifier, withView: self, handler: { $0.backgroundColor == $1.value })
        return self
    }

    func updateIsUserInteractionEnabled(from viewState: ReadOnlyViewState<Bool>, identifier: AnyHashable? = nil) -> Self {
        viewState.addViewStateObservation(identifier: identifier, withView: self, keyPath: \.isUserInteractionEnabled)
        return self
    }
}
