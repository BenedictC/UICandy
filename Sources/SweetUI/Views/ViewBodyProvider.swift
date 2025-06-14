import Foundation
import UIKit


// ViewBodyProvider can only be conformed to by UIView subclasses marked `final`. However, the core functionality
// supporting ViewBodyProvider is usually provided by the final class's superclass but said superclass cannot conform
// to ViewBodyProvider because doing so would mean that it would be responsible for providing the type of Body.
// Therefore we must jump up and down the types in order for the superclass to provide the functionality.
// ViewBodyProvider is a PAC so cannot by arbitrarily cast. To work around this ViewBodyProvider conforms to a non-PAC
// called _ViewBodyProvider which can be arbitrarily cast to. Specifically, `_initializeBody()` on _ViewBodyProvider
// has a default implementation provided by ViewBodyProvider so that calling it on a _ViewBodyProvider means the type
// is narrowed/(demoted?) from _ViewBodyProvider to ViewBodyProvider and can thus reference the associated types.
public protocol ViewBodyProvider: _ViewBodyProvider {

    // Required
    associatedtype Body: UIView
    var body: Body { get }

    // Optional from _ViewBodyProvider (and duplicated for clarity)
    func awake()
    var bodyContainer: UIView { get }
    func arrangeBody(_ body: UIView, in container: UIView)

    // Called in the init of View, Control, CollectionViewCell and CollectionReusableView. If a class conforms to
    // ViewBodyProvider but does not subclass from one of these 4 classes then it must call initializeBodyHosting()
    // from its init.
    @MainActor
    func initializeBodyHosting()
}


public protocol _ViewBodyProvider: UIView { // Core functionality avoiding associated types

    // Implemented by ViewBodyProvider. Should not be overridden.
    @MainActor
    func _initializeBodyHosting()
}


// MARK: - Core

public extension UIView {

    static func initializeBodyHosting(of view: UIView) {
        guard let bodyProvider = view as? _ViewBodyProvider else {
            preconditionFailure("body hosting views must conform to ViewBodyProvider")
        }
        bodyProvider.initializeBodyHosting()
    }
}


public extension _ViewBodyProvider {

    @MainActor
    func initializeBodyHosting() {
        _initializeBodyHosting()
    }
}


public extension ViewBodyProvider {

    var bodyContainer: UIView { self }

    func awake() {
        // Default do nothing
    }
    
    @MainActor
    func _initializeBodyHosting() {
        if body.superview == nil { // This causes body to be loaded
            detectPotentialRetainCycle(of: self) {
                self.awake()
            }
        }
        detectPotentialRetainCycle(of: self) {
            let container = self.bodyContainer
            let isSelfHosted = body == container
            if !isSelfHosted {
                arrangeBody(body, in: container)
            }
        }
    }
}
