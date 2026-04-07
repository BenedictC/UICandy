import UIKit


// MARK: - ItemRepresentable

@MainActor
public protocol ItemRepresentable: UIView {

    associatedtype Item = Void

    var item: Item? { get set }
}


// MARK: Default implementation

public extension ItemRepresentable where Item == Void {

    var item: Void? {
        get { () }
        set {  }
    }
}
