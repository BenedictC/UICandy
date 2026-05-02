import UIKit


public class Container<Content>: UIView {

    public internal(set) var content: Content!
    public var allowsPassThrough: Bool = false


    public init(content: Content!) {
        self.content = content
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)

        let shouldExclude = view == self || !(view?.isUserInteractionEnabled ?? false)
        return allowsPassThrough && shouldExclude ? nil : view
    }
}


// MARK: - Initializers

public extension Container {

    convenience init(content: Content, arrangeUsing contentConfigurator: (Content, Self) -> Void) where Content: UIView {
        self.init(content: content)
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        contentConfigurator(content, self)
    }

    convenience init(unarrangedContent: Content, arrangeUsing contentConfigurator: (Content, Self) -> Void) {
        self.init(content: unarrangedContent)
        contentConfigurator(unarrangedContent, self)
    }
}


// MARK: - Modifiers

public extension Container {

    func allowsPassThrough(_ value: Bool) -> Self {
        self.allowsPassThrough = value
        return self
    }
}
