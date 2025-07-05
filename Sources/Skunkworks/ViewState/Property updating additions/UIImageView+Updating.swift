import UIKit
import Combine


// MARK: - Modifiers

public extension UIImageView {
     
    func updateImage(from viewState: ReadOnlyViewState<UIImage?>, identifier: AnyHashable? = nil) -> Self {
        viewState.addViewStateObservation(identifier: identifier, withView: self, keyPath: \.image)
        return self
    }
    
    func updateImage(from viewState: ReadOnlyViewState<UIImage>, identifier: AnyHashable? = nil) -> Self {
        viewState.addViewStateObservation(identifier: identifier, withView: self, handler: { $0.image = $1.value })
        return self
    }
}
