import Foundation
import UIKit


public extension UIStackView {

    convenience init(axis: NSLayoutConstraint.Axis,  distribution: UIStackView.Distribution = .fill, alignment: UIStackView.Alignment = .fill, spacing: CGFloat = UIStackView.spacingUseDefault,  @SubviewsBuilder arrangedSubviewsBuilder: () -> [UIView]) {
        let arrangedSubviews = arrangedSubviewsBuilder()
        for subview in arrangedSubviews {
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing
    }
}
