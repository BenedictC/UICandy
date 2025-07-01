import UIKit
import Combine


// MARK: - Text

public extension UILabel {
    
    func updateText(from viewState: ReadOnlyViewState<String?>, identifier: AnyHashable? = nil) -> Self {
        viewState.addViewStateObservation(identifier: identifier, withView: self, keyPath: \.text)
        return self
    }
    
    func updateText(from viewState: ReadOnlyViewState<String>, identifier: AnyHashable? = nil) -> Self {
        viewState.addViewStateObservation(identifier: identifier, withView: self, handler: { $0.text = $1.value })
        return self
    }
}


// MARK: - AttributedText

public extension UILabel {

    func updateAttributedText(from viewState: ReadOnlyViewState<NSAttributedString?>, identifier: AnyHashable? = nil) -> Self {
        viewState.addViewStateObservation(identifier: identifier, withView: self, keyPath: \.attributedText)
        return self
    }

    func updateAttributedText(from viewState: ReadOnlyViewState<NSAttributedString>, identifier: AnyHashable? = nil) -> Self {
        viewState.addViewStateObservation(identifier: identifier, withView: self, handler: { $0.attributedText = $1.value })
        return self
    }
}
