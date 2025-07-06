import UIKit


public extension UIVisualEffectView {

    func effect(_ value: UIVisualEffect) -> Self {
        effect = value
        return self
    }
}


public class VisualEffectView<Content: UIView>: UIVisualEffectView {

    public let content: Content


    init(effect: UIVisualEffect?, content: Content) {
        self.content = content
        super.init(effect: effect)
        contentView.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: contentView.topAnchor),
            content.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            content.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            content.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


public extension SomeView {

    func visualEffect(_ effect: UIVisualEffect) -> VisualEffectView<Self> {
        VisualEffectView(effect: effect, content: self)
    }

    func blurEffect(_ style: UIBlurEffect.Style) -> VisualEffectView<Self> {
        let effect = UIBlurEffect(style: style)
        return VisualEffectView(effect: effect, content: self)
    }

    func vibrancyEffect(_ vibrancyStyle: UIVibrancyEffectStyle, blurStyle: UIBlurEffect.Style) -> VisualEffectView<Self> {
        let blurEffect = UIBlurEffect(style: blurStyle)
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect, style: vibrancyStyle)
        return VisualEffectView(effect: vibrancyEffect, content: self)
    }
}
