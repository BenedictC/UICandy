import Foundation
import Combine
import UIKit


public extension UIPageControl {
    
    func updateNumberOfPages(from viewState: ReadOnlyViewState<Int>, identifier: AnyHashable? = nil) -> Self {
        viewState.addViewStateObservation(identifier: identifier, withView: self, keyPath: \.numberOfPages)
        return self
    }

    func updateCurrentPage(from viewState: ReadOnlyViewState<Int>, identifier: AnyHashable? = nil) -> Self {
        viewState.addViewStateObservation(identifier: identifier, withView: self, keyPath: \.currentPage)
        return self
    }
}
