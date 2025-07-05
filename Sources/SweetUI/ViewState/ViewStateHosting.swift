
public protocol ViewStateHosting: AnyObject {

    func initializeViewStateHosting()

    func setViewStateDidChange()
}


// MARK: Default implementations

public extension ViewStateHosting {

    func initializeViewStateHosting() {
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if let viewState = child.value as? BaseViewState {
                viewState.addHost(self)
            }
        }
    }
}


extension ViewStateHosting where Self: UIView {

    public func setViewStateDidChange() {
        if #available(iOS 14, *) {
            if let cell = self as? UICollectionViewCell {
                cell.setNeedsUpdateConfiguration()
            } else {
                setNeedsLayout()
            }
        } else {
            setNeedsLayout()
        }
    }
}


extension ViewStateHosting where Self: UIViewController {

    public func setViewStateDidChange() {
        guard isViewLoaded else { return }
        view?.setNeedsLayout()
    }
}
