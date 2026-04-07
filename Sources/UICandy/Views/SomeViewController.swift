import UIKit


public protocol _SomeViewController: UIViewController, SomeObject {

}


// MARK: - Default conformance

// This isn't pretty, because we're polluting a large number of classes, but it is useful.
extension UIViewController: _SomeViewController { }
