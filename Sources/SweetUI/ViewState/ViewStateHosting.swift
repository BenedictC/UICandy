import UIKit


public protocol ViewStateHosting: AnyObject {

    func initializeViewStateHosting()
    func setViewStateDidChange()
}


// MARK: - Default implementations

public extension ViewStateHosting {

    func initializeViewStateHosting() {
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if let viewState = child.value as? BaseViewState {
                viewState.addHost(self)
            }
        }
        setViewStateDidChange()
    }
}


// MARK: - Debug

extension ViewStateHosting {

    func warnOfReentrantUpdateProperties() {
        let message = "Object <\(self)> recursively called updateProperties(). This may cause deadlocks."
        runtimeWarn(message)
    }
}
