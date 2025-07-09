import UIKit


public extension UISegmentedControl {


    func momentary(_ value: Bool) -> Self {
        isMomentary = value
        return self
    }

    func apportionsSegmentWidthsByContent(_ value: Bool) -> Self {
        apportionsSegmentWidthsByContent = value
        return self
    }


//    open func insertSegment(withTitle title: String?, at segment: Int, animated: Bool) // insert before segment number. 0..#segments. value pinned
//
//    open func insertSegment(with image: UIImage?, at segment: Int, animated: Bool)
//
//    open func removeSegment(at segment: Int, animated: Bool)
//
//    open func removeAllSegments()
//
//
//    open func setTitle(_ title: String?, forSegmentAt segment: Int) // can only have image or title, not both. must be 0..#segments - 1 (or ignored). default is nil
//
//    open func titleForSegment(at segment: Int) -> String?
//
//
//    open func setImage(_ image: UIImage?, forSegmentAt segment: Int) // can only have image or title, not both. must be 0..#segments - 1 (or ignored). default is nil
//
//    open func imageForSegment(at segment: Int) -> UIImage?
//
//
//    open func setWidth(_ width: CGFloat, forSegmentAt segment: Int) // set to 0.0 width to autosize. default is 0.0
//
//    open func widthForSegment(at segment: Int) -> CGFloat
//
//
//    open func setContentOffset(_ offset: CGSize, forSegmentAt segment: Int) // adjust offset of image or text inside the segment. default is (0,0)
//
//    open func contentOffsetForSegment(at segment: Int) -> CGSize
//
//
//    open func setEnabled(_ enabled: Bool, forSegmentAt segment: Int) // default is YES
//
//    open func isEnabledForSegment(at segment: Int) -> Bool


    func selectedSegmentIndex(_ value: Int) -> Self {
        self.selectedSegmentIndex = value
        return self
    }

    func selectedSegmentTintColor(_ value: UIColor?) -> Self {
        self.selectedSegmentTintColor = value
        return self
    }

//    /* If backgroundImage is an image returned from -[UIImage resizableImageWithCapInsets:] the cap widths will be calculated from that information, otherwise, the cap width will be calculated by subtracting one from the image's width then dividing by 2. The cap widths will also be used as the margins for text placement. To adjust the margin use the margin adjustment methods.
//
//     In general, you should specify a value for the normal state to be used by other states which don't have a custom value set.
//
//     Similarly, when a property is dependent on the bar metrics, be sure to specify a value for UIBarMetricsDefault.
//     In the case of the segmented control, appearance properties for UIBarMetricsCompact are only respected for segmented controls in the smaller navigation and toolbars.
//     */
//    open func setBackgroundImage(_ backgroundImage: UIImage?, for state: UIControl.State, barMetrics: UIBarMetrics)
//
//    open func backgroundImage(for state: UIControl.State, barMetrics: UIBarMetrics) -> UIImage?
//
//
//    /* To customize the segmented control appearance you will need to provide divider images to go between two unselected segments (leftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal), selected on the left and unselected on the right (leftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal), and unselected on the left and selected on the right (leftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected).
//     */
//    open func setDividerImage(_ dividerImage: UIImage?, forLeftSegmentState leftState: UIControl.State, rightSegmentState rightState: UIControl.State, barMetrics: UIBarMetrics)
//
//    open func dividerImage(forLeftSegmentState leftState: UIControl.State, rightSegmentState rightState: UIControl.State, barMetrics: UIBarMetrics) -> UIImage?
//
//
//    /* You may specify the font, text color, and shadow properties for the title in the text attributes dictionary, using the keys found in NSAttributedString.h.
//     */
//    open func setTitleTextAttributes(_ attributes: [NSAttributedString.Key : Any]?, for state: UIControl.State)
//
//    open func titleTextAttributes(for state: UIControl.State) -> [NSAttributedString.Key : Any]?
//
//
//    /* For adjusting the position of a title or image within the given segment of a segmented control.
//     */
//    open func setContentPositionAdjustment(_ adjustment: UIOffset, forSegmentType leftCenterRightOrAlone: UISegmentedControl.Segment, barMetrics: UIBarMetrics)
//
//    open func contentPositionAdjustment(forSegmentType leftCenterRightOrAlone: UISegmentedControl.Segment, barMetrics: UIBarMetrics) -> UIOffset
}


//@available(iOS 14.0, *)
//public extension UISegmentedControl {
//
//    open func insertSegment(action: UIAction, at segment: Int, animated: Bool)
//    open func setAction(_ action: UIAction, forSegmentAt segment: Int)
//    open func actionForSegment(at segment: Int) -> UIAction?
//    open func segmentIndex(identifiedBy actionIdentifier: UIAction.Identifier) -> Int
//
//}


public extension UISegmentedControl {

    func setTitleTextAttributes(_ attributes: [NSAttributedString.Key : Any]?, state: UIControl.State = .normal) -> Self {
        self.setTitleTextAttributes(attributes, for: state)
        return self
    }    
}
