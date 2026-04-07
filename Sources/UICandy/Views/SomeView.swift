import UIKit


public protocol SomeView: UIView, SomeObject {

}


// MARK: - Default conformance

// This isn't pretty, because we're polluting a large number of classes, but it is useful.
extension UIView: SomeView { }
