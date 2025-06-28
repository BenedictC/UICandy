import UIKit


public final class ImageView: UIImageView {

    // MARK: Properties

    public var maintainsAspectRatio: Bool {
        didSet { updateAspectRatioConstraint() }
    }

    public override var image: UIImage? {
        get { super.image }
        set { super.image = newValue;  updateAspectRatioConstraint() }
    }

    private var aspectRatioConstraint: NSLayoutConstraint?


    // MARK: Life cycle

    public init(maintainsAspectRatio: Bool = true, image: UIImage? = nil, highlightedImage: UIImage? = nil) {
        self.maintainsAspectRatio = maintainsAspectRatio
        super.init(image: image, highlightedImage: highlightedImage)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: Constraint management

    private func updateAspectRatioConstraint() {
        guard let image else {
            aspectRatioConstraint?.isActive = false
            aspectRatioConstraint = nil
            return
        }

        let newSize = image.size
        let ratio = newSize.width / newSize.height
        let isChanged = ratio != aspectRatioConstraint?.multiplier
        guard isChanged else { return }

        self.aspectRatioConstraint = NSLayoutConstraint.aspectConstraint(view: self, multiplier: ratio).priority(.almostRequired)
        self.aspectRatioConstraint?.isActive = true
    }
}
