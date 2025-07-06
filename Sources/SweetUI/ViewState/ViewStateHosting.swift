import UIKit


public protocol ViewStateHosting: AnyObject {

    func initializeViewStateHosting()

    func setViewStateDidChange()

    func addOnUpdatePropertiesHandler(withIdentifier identifier: AnyHashable?, action: @escaping () -> Void)
    func removeOnUpdatePropertiesHandler(withIdentifier identifier: AnyHashable)
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


// MARK: - OnUpdateProperties

struct OnUpdatePropertiesHandler: Hashable {

    let identifier: AnyHashable?
    let handler: () -> Void

    static func ==(lhs: OnUpdatePropertiesHandler, rhs: OnUpdatePropertiesHandler) -> Bool {
        lhs.identifier == rhs.identifier
    }

    func hash(into hasher: inout Hasher) {
        guard let identifier else {
            hasher.combine(0)
            return
        }
        hasher.combine(identifier)
    }

    func execute() {
        handler()
    }
}


public extension ViewStateHosting {

    func onUpdateProperties(identifier: AnyHashable? = nil, perform handler: @escaping (Self) -> Void) -> Self {
        addOnUpdatePropertiesHandler(withIdentifier: identifier, action: { [weak self] in
            guard let self else { return }
            handler(self)
        })
        return self
    }
}


public extension SomeObject {

    func onUpdateProperties<Host: ViewStateHosting>(of host: Host, identifier: AnyHashable? = nil, perform handler: @escaping (Self, Host) -> Void) -> Self {
        host.addOnUpdatePropertiesHandler(withIdentifier: identifier, action: { [weak self, weak host] in
            guard let self, let host else { return }
            handler(self, host)
        })
        return self
    }
}


//
