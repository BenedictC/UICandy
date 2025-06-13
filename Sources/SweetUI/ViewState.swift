import UIKit


@propertyWrapper
public struct ViewState<T> {

   @available(*, unavailable, message: "@Node is only available on properties of classes")
   public var wrappedValue: T {
       get { value }
       set { value = newValue }
   }


   private var value: T


   public static subscript<EnclosingObject: ViewStateUpdating>(
       _enclosingInstance object: EnclosingObject,
       wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingObject, T>,
       storage storageKeyPath: ReferenceWritableKeyPath<EnclosingObject, ViewState<T>>
   ) -> T {
       get {
           let storage = object[keyPath: storageKeyPath]
           return storage.value
       }
       set {
           var storage = object[keyPath: storageKeyPath]
           storage.value = newValue
           object.setNeedsLayout()
       }
   }

   public init(wrappedValue: T) {
       self.value = wrappedValue
   }
}


public protocol ViewStateUpdating {

   func setNeedsLayout()
}


extension UIViewController: ViewStateUpdating {

   public func setNeedsLayout() {
       guard isViewLoaded else { return }
       view?.setNeedsLayout()
   }
}


func todo() {
    "UICollectionViewCell.updateConfiguration(using:)"
}
