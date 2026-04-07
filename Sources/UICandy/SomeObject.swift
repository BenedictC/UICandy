import Foundation


public protocol SomeObject: AnyObject { 
    
}


// MARK: - Configure

public extension SomeObject {

    func set<T>(_ keyPath: ReferenceWritableKeyPath<Self, T>, to value: T) -> Self {
        self[keyPath: keyPath] = value
        return self
    }

    func configure(using closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}


// MARK: - Default conformance

// This isn't pretty, because we're polluting a large number of classes, but it is useful.
extension NSObject: SomeObject { }


