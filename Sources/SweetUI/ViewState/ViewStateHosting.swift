
public protocol ViewStateHosting: AnyObject {

    var viewStateObservations: [ViewStateObservation] { get set }

    func initializeViewStateObserving()
    func registerViewStateObservation(_ update: ViewStateObservation)
    func setViewStateDidChange()
    func performViewStateObservationUpdates()
}


// MARK: Default implementations

public extension ViewStateHosting {

    func initializeViewStateObserving() {
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if let viewState = child.value as? AnyViewState {
                viewState.host = self
            }
        }
    }

    func registerViewStateObservation(_ update: ViewStateObservation) {
        viewStateObservations.append(update)
    }

    func performViewStateObservationUpdates() {
        var fresh = [ViewStateObservation]()
        for update in viewStateObservations {
            if update.performUpdate() {
                fresh.append(update)
            }
        }
        viewStateObservations = fresh
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
