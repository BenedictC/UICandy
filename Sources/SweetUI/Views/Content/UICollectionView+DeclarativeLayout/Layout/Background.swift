import UIKit


public struct Background: Decoration {

    public let elementKind: String
    let zIndex: Int?
    private let viewRegistrar: (UICollectionViewLayout) -> Void

    public init(elementKind: String, zIndex: Int?, viewRegistrar: @escaping (UICollectionViewLayout) -> Void) {
        self.elementKind = elementKind
        self.zIndex = zIndex
        self.viewRegistrar = viewRegistrar
    }

    public func registerDecorationView(in layout: UICollectionViewLayout) {
        viewRegistrar(layout)
    }

    public func makeLayoutDecorationItem() -> NSCollectionLayoutDecorationItem {
        NSCollectionLayoutDecorationItem.background(elementKind: elementKind)
    }
}


public extension Background {

    init<T: UICollectionReusableView>(
        viewClass: T.Type,
        elementKind optionalElementKind: String? = nil,
        zIndex: Int? = nil
    ) {
        let elementKind = optionalElementKind ?? UniqueIdentifier("Section Background").value
        let viewClass = T.self
        let viewRegistrar = { (layout: UICollectionViewLayout) in
            layout.register(viewClass, forDecorationViewOfKind: elementKind)
        }
        self.init(elementKind: elementKind, zIndex: zIndex, viewRegistrar: viewRegistrar)
    }

    init(
        elementKind optionalElementKind: String? = nil,
        zIndex: Int? = nil,
        bodyFactory: @escaping () -> UIView
    ) {
        let elementKind = optionalElementKind ?? UniqueIdentifier("Section Background").value
        let viewClass: AnyClass = ConfigurableBackground.makeSubclass(bodyFactory: bodyFactory)
        let viewRegistrar = { (layout: UICollectionViewLayout) in
            layout.register(viewClass, forDecorationViewOfKind: elementKind)
        }
        self.init(elementKind: elementKind, zIndex: zIndex, viewRegistrar: viewRegistrar)
    }
}


// MARK: - ConfigurableBackground

// We can't use StaticContentReusableCollectionView because decorationViews cannot be configured once they've been dequeued.
private class ConfigurableBackground: UICollectionReusableView {

    static var classAndBodyFactoryPairs = [(class: AnyClass, factory: () -> UIView)]()

    static func makeSubclass(bodyFactory: @escaping () -> UIView) -> AnyClass {
        let name = UniqueIdentifier("\(ConfigurableBackground.self)").value
        let subclass: AnyClass = objc_allocateClassPair(ConfigurableBackground.self, name, 0)!
        classAndBodyFactoryPairs.append((subclass, bodyFactory))
        return subclass
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeAndConfigureBody()
    }

    private func makeAndConfigureBody() {
        guard let thisClass = object_getClass(self),
        let pair = ConfigurableBackground.classAndBodyFactoryPairs.first(where: { $0.class == thisClass }) else {
            return
        }
        let body = pair.factory()

        body.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(body)
        NSLayoutConstraint.activate([
            body.leftAnchor.constraint(equalTo: self.leftAnchor),
            body.rightAnchor.constraint(equalTo: self.rightAnchor),
            body.topAnchor.constraint(equalTo: self.topAnchor),
            body.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
