import UIKit


public extension SomeView where Self: UISwitch {

    func updateIsOn(from viewState: ReadOnlyViewState<Bool>, identifier: AnyHashable? = nil) -> Self {
        viewState.addViewStateObservation(identifier: identifier, withView: self, keyPath: \.isOn)
        return self
    }
}
