import UIKit


public extension UIMenu {

    typealias MenuBuilder = ArrayBuilder<UIMenuElement>
    
    convenience init(title: String = "", image: UIImage? = nil, identifier: UIMenu.Identifier? = nil, options: UIMenu.Options = [], @MenuBuilder childrenBuilder: () -> [UIMenuElement]) {
        let children = childrenBuilder()
        self.init(title: title, image: image, identifier: identifier, options: options, children: children)
    }

    @available(iOS 15.0, tvOS 15.0, *)
    convenience init(title: String = "", subtitle: String? = nil, image: UIImage? = nil, identifier: UIMenu.Identifier? = nil, options: UIMenu.Options = [], @MenuBuilder childrenBuilder: () -> [UIMenuElement]) {
        let children = childrenBuilder()
        self.init(title: title, subtitle: subtitle, image: image, identifier: identifier, options: options, children: children)
    }

    @available(iOS 16.0, tvOS 16.0, *)
    convenience init(title: String = "", subtitle: String? = nil, image: UIImage? = nil, identifier: UIMenu.Identifier? = nil, options: UIMenu.Options = [], preferredElementSize: UIMenu.ElementSize = { if #available(iOS 17.0, tvOS 17.0, *) { .automatic } else { .large } }(), @MenuBuilder childrenBuilder: () -> [UIMenuElement]) {
        let children = childrenBuilder()
        self.init(title: title, subtitle: subtitle, image: image, identifier: identifier, options: options, preferredElementSize: preferredElementSize, children: children)
    }
}
