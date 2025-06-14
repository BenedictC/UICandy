import Foundation


// MARK: - CancellableStorageKey

public struct CancellableStorageKey: Equatable, Hashable {

    public let identifier: AnyHashable

    public init(identifier: AnyHashable) {
        self.identifier = identifier
    }
}


// MARK: - CancellableStorageKey factories

public extension CancellableStorageKey {

    private static var propertyUUIDsByKeyPath = [AnyHashable: UUID]()

    static func property<R: AnyObject, P>(_ keyPath: KeyPath<R, P>, of object: R) -> Self {
        let uuid: UUID
        if let existing = propertyUUIDsByKeyPath[keyPath] {
            uuid = existing
        } else {
            uuid = UUID()
            propertyUUIDsByKeyPath[keyPath] = uuid
        }
        return .named(uuid.uuidString, for: object)
    }

    static func named(_ name: String, for object: AnyObject? = nil) -> Self {
        let pointer = object.flatMap { "\(Unmanaged.passUnretained($0).toOpaque())" } ?? ""
        let identifier = "\(pointer):\(name)"
        return CancellableStorageKey(identifier: identifier)
    }

    static func unique() -> Self {
        return CancellableStorageKey(identifier: UUID())
    }
}
