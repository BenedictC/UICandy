import Foundation
import Combine
import UIKit


public extension UISegmentedControl {

    func updateSelectedSegmentIndex(from viewState: ViewState<Int>, identifier: AnyHashable? = nil) -> Self {
        viewState.addViewStateObservation(identifier: identifier, withView: self, keyPath: \.selectedSegmentIndex)
        return self
    }
}
