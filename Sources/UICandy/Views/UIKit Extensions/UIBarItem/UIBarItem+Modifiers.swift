import UIKit


// MARK: SomeObject

// extension UIBarItem: SomeObject { }


// MARK: Properties

public extension UIBarItem {


    func landscapeImagePhone(_ value: UIImage?) -> Self {
        landscapeImagePhone = value
        return self
    }

    func largeContentSizeImage(_ value: UIImage?) -> Self {
        largeContentSizeImage = value
        return self
    }

    func imageInsets(_ value: UIEdgeInsets) -> Self {
        imageInsets = value
        return self
    }

    func landscapeImagePhoneInsets(_ value: UIEdgeInsets) -> Self {
        landscapeImagePhoneInsets = value
        return self
    }

    func largeContentSizeImageInsets(_ value: UIEdgeInsets) -> Self {
        largeContentSizeImageInsets = value
        return self
    }
}


// MARK: Properties

public extension UIBarItem {

    func enabled(_ value: Bool) -> Self {
        isEnabled = value
        return self
    }

    func enabled(_ value: String?) -> Self {
        title = value
        return self
    }

    func image(_ value: UIImage?) -> Self {
        image = value
        return self
    }
}
