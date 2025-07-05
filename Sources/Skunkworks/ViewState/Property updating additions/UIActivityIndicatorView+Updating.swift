import UIKit


public extension UIActivityIndicatorView {
    
    func updateIsActive(from viewState: ReadOnlyViewState<Bool>, identifier: AnyHashable? = nil) -> Self {
        viewState.addViewStateObservation(identifier: identifier, withView: self, keyPath: \.isActive)
        return self
    }
}
