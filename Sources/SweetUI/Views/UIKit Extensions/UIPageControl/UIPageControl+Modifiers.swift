import UIKit


public extension UIPageControl {
    
    func numberOfPages(_ value: Int) -> Self {
        numberOfPages = value
        return self
    }
    
    func currentPage(_ value: Int) -> Self {
        currentPage = value
        return self
    }
    
    func hidesForSinglePage(_ value: Bool) -> Self {
        hidesForSinglePage = value
        return self
    }
    
    func pageIndicatorTintColor(_ value: UIColor?) -> Self {
        pageIndicatorTintColor = value
        return self
    }
    
    func currentPageIndicatorTintColor(_ value: UIColor?) -> Self {
        currentPageIndicatorTintColor = value
        return self
    }
}


@available(iOS 14.0, *)
public extension UIPageControl {
    
    func backgroundStyle(_ value: UIPageControl.BackgroundStyle) -> Self {
        backgroundStyle = value
        return self
    }
        
    func allowsContinuousInteraction(_ value: Bool) -> Self {
        allowsContinuousInteraction = value
        return self
    }
    
    func preferredIndicatorImage(_ value: UIImage?) -> Self {
        preferredIndicatorImage = value
        return self
    }
    
    func indicatorImage(_ image: UIImage?, forPage page: Int) -> Self {
        setIndicatorImage(image, forPage: page)
        return self
    }
}


@available(iOS, introduced: 2.0, deprecated: 14.0, message: "defersCurrentPageDisplay no longer does anything reasonable with the new interaction mode.")
public extension UIPageControl {
    
    func defersCurrentPageDisplay(_ value: Bool) -> Self {
        defersCurrentPageDisplay = value
        return self
    }
}

