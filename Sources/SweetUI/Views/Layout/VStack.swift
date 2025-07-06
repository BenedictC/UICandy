import UIKit


public final class VStack: UIStackView {

    @available(*, unavailable)
    public override var axis: NSLayoutConstraint.Axis {
        get { super.axis }
        set { super.axis = newValue }
    }

    public init(distribution: UIStackView.Distribution = .fill, alignment: UIStackView.Alignment = .fill, spacing: CGFloat = UIStackView.spacingUseDefault, arrangedSubviews: [UIView] = []) {
        super.init(frame: .zero)
        super.axis = .vertical

        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing

        arrangedSubviews.forEach { self.addArrangedSubview($0) }

    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


public extension VStack {

    convenience init(distribution: UIStackView.Distribution = .fill, alignment: UIStackView.Alignment = .fill, spacing: CGFloat = UIStackView.spacingUseDefault,  @SubviewsBuilder arrangedSubviewsBuilder: () -> [UIView]) {
        let arrangedSubviews = arrangedSubviewsBuilder()
        self.init(distribution: distribution, alignment: alignment, spacing: spacing, arrangedSubviews: arrangedSubviews)
    }
}
