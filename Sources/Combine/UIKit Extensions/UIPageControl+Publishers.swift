import Foundation
import Combine
import UIKit


public extension UIPageControl {
    
    func numberOfPages(_ publisher: some Publisher<Int, Never>) -> Self {
        onChange(of: publisher) { $0.numberOfPages = $1 }
    }
    
    func currentPage(_ publisher: some Publisher<Int, Never>) -> Self {
        onChange(of: publisher) { $0.currentPage = $1 }
        return self
    }
}


public extension UIPageControl {

    convenience init(numberOfPages: Int, currentPage subject: some Subject <Int, Never>) {
        self.init(frame: .zero)
        self.numberOfPages = numberOfPages
        _ = onEvent(.valueChanged) { pageControl in
            subject.send(pageControl.currentPage)
        }
        _ = onChange(of: subject) { $0.currentPage = $1 }
    }
}
