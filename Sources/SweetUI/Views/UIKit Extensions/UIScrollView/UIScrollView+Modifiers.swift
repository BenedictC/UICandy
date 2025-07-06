import UIKit


public extension UIScrollView {

    func contentOffset(_ value: CGPoint) -> Self {
        contentOffset = value
        return self
    }

    func contentSize(_ value: CGSize) -> Self {
        contentSize = value
        return self
    }

    func contentInset(_ value: UIEdgeInsets) -> Self {
        contentInset = value
        return self
    }

    func directionalLockEnabled(_ value: Bool) -> Self {
        isDirectionalLockEnabled = value
        return self
    }

    func bounces(_ value: Bool) -> Self {
        bounces = value
        return self
    }

    func alwaysBounceVertical(_ value: Bool) -> Self {
        alwaysBounceVertical = value
        return self
    }

    func alwaysBounceHorizontal(_ value: Bool) -> Self {
        alwaysBounceHorizontal = value
        return self
    }

    func scrollEnabled(_ value: Bool) -> Self {
        isScrollEnabled = value
        return self
    }

    func showsVerticalScrollIndicator(_ value: Bool) -> Self {
        showsVerticalScrollIndicator = value
        return self
    }

    func showsHorizontalScrollIndicator(_ value: Bool) -> Self {
        showsHorizontalScrollIndicator = value
        return self
    }

    func indicatorStyle(_ value: UIScrollView.IndicatorStyle) -> Self {
        indicatorStyle = value
        return self
    }

    func verticalScrollIndicatorInsets(_ value: UIEdgeInsets) -> Self {
        verticalScrollIndicatorInsets = value
        return self
    }

    func horizontalScrollIndicatorInsets(_ value: UIEdgeInsets) -> Self {
        horizontalScrollIndicatorInsets = value
        return self
    }

    func scrollIndicatorInsets(_ value: UIEdgeInsets) -> Self {
        scrollIndicatorInsets = value
        return self
    }

    func decelerationRate(_ value: UIScrollView.DecelerationRate) -> Self {
        decelerationRate = value
        return self
    }

    func indexDisplayMode(_ value: UIScrollView.IndexDisplayMode) -> Self {
        indexDisplayMode = value
        return self
    }

    func minimumZoomScale(_ value: CGFloat) -> Self {
        minimumZoomScale = value
        return self
    }

    func maximumZoomScale(_ value: CGFloat) -> Self {
        maximumZoomScale = value
        return self
    }

    func zoomScale(_ value: CGFloat) -> Self {
        zoomScale = value
        return self
    }

    func bouncesZoom(_ value: Bool) -> Self {
        bouncesZoom = value
        return self
    }

    func refreshControl(_ value: UIRefreshControl) -> Self {
        refreshControl = value
        return self
    }

    func contentInsetAdjustmentBehavior(_ value: UIScrollView.ContentInsetAdjustmentBehavior) -> Self {
        contentInsetAdjustmentBehavior = value
        return self
    }

    func automaticallyAdjustsScrollIndicatorInsets(_ value: Bool) -> Self {
        automaticallyAdjustsScrollIndicatorInsets = value
        return self
    }
}


@available(tvOS, unavailable)
public extension UIScrollView {

    func pagingEnabled(_ value: Bool) -> Self {
        isPagingEnabled = value
        return self
    }

    func scrollsToTop(_ value: Bool) -> Self {
        scrollsToTop = value
        return self
    }
}
