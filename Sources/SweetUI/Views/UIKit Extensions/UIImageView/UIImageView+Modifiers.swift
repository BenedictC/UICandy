import UIKit


// MARK: - Init

public extension UIImageView {

    convenience init(imageNamed imageName: String, highlightedImageNamed: String? = nil, in bundle: Bundle = .main, with configuration: UIImage.Configuration? = nil) {
        let image = UIImage(named: imageName, in: bundle, with: configuration)
        let highlightedImage = highlightedImageNamed.flatMap { UIImage(named: $0, in: bundle, with: configuration) }
        self.init(image: image, highlightedImage: highlightedImage)
    }

    convenience init(systemImageNamed systemName: String, highlightedSystemImageNamed highlightedSystemName: String? = nil, configuration: UIImage.Configuration? = nil) {
        let image = UIImage(systemName: systemName, withConfiguration: configuration)
        let highlightedImage = highlightedSystemName.flatMap { UIImage(systemName: $0, withConfiguration: configuration) }
        self.init(image: image, highlightedImage: highlightedImage)
    }
}


// MARK: - Modifiers

public extension UIImageView {

    func image(_ value: UIImage?) -> Self {
        self.image = value
        return self
    }

    func highlightedImage(_ value: UIImage?) -> Self {
        self.highlightedImage = value
        return self
    }

    func preferredSymbolConfiguration(_ value: UIImage.SymbolConfiguration?) -> Self {
        self.preferredSymbolConfiguration = value
        return self
    }

    func isUserInteractionEnabled(_ value: Bool) -> Self {
        self.isUserInteractionEnabled = value
        return self
    }

    func isHighlighted(_ value: Bool) -> Self {
        self.isHighlighted = value
        return self
    }


    func animationImages(_ value: [UIImage]?) -> Self {
        self.animationImages = value
        return self
    }

    func highlightedAnimationImages(_ value: [UIImage]?) -> Self {
        self.highlightedAnimationImages = value
        return self
    }

    func animationDuration(_ value: TimeInterval) -> Self {
        self.animationDuration = value
        return self
    }

    func animationRepeatCount(_ value: Int) -> Self {
        self.animationRepeatCount = value
        return self
    }


    func animate(_ value: Bool) -> Self {
        if value {
            startAnimating()
        } else {
            stopAnimating()
        }
        return self
    }
}
