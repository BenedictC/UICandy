import UIKit


public struct DecorationAlignment {

    // MARK: Types

    public typealias ConstraintsBuilder = ((_ template: ConstraintsTemplate, _ base: UIView, _ decoration: UIView) -> [NSLayoutConstraint])

    public struct ConstraintsTemplate {
        let baseX: XPosition
        let baseY: YPosition
        var decorationX: XPosition?
        var decorationY: YPosition?
        // Positive x moves from leading to trailing or left to right depending on the value of baseX.
        // Positive y moves top to bottom.
        var offset = CGSize.zero
    }


    // MARK: Properties

    var template: ConstraintsTemplate
    let builder: ConstraintsBuilder


    // MARK: Instance life cycle

    public init(x: XPosition, y: YPosition, builder: @escaping ConstraintsBuilder = Self.defaultConstraintsBuilder) {
        self.template = ConstraintsTemplate(baseX: x, baseY: y)
        self.builder = builder
    }

    public init(builder: @escaping (_ base: UIView, _ decoration: UIView) -> [NSLayoutConstraint]) {
        self.template = ConstraintsTemplate(baseX: .center, baseY: .center)
        self.builder = { _, base, decoration in
            builder(base, decoration)
        }
    }


    // MARK: Constraints factory

    public static func defaultConstraintsBuilder(template: ConstraintsTemplate, base: UIView, decoration: UIView) -> [NSLayoutConstraint] {
        func xAnchor(of view: UIView, for position: XPosition) -> NSLayoutXAxisAnchor {
            switch position {
            case .left: view.leftAnchor
            case .center: view.centerXAnchor
            case .right: view.rightAnchor
            case .leading: view.leadingAnchor
            case .trailing: view.trailingAnchor
            }
        }
        func yAnchor(of view: UIView, for position: YPosition) -> NSLayoutYAxisAnchor {
            switch position {
            case .top: view.topAnchor
            case .center: view.centerYAnchor
            case .bottom: view.bottomAnchor
            }
        }

        let baseXAnchor = xAnchor(of: base, for: template.baseX)
        let decorationXAnchor = xAnchor(of: decoration, for: template.decorationX ?? template.baseX)
        let baseYAnchor = yAnchor(of: base, for: template.baseY)
        let decorationYAnchor = yAnchor(of: decoration, for: template.decorationY ?? template.baseY)
        let constraints = [
            baseXAnchor.constraint(equalTo: decorationXAnchor, constant: -template.offset.width),
            baseYAnchor.constraint(equalTo: decorationYAnchor, constant: -template.offset.height),
        ]

        return constraints
    }

    public func makeConstraints(base: UIView, decoration: UIView) -> [NSLayoutConstraint] {
        builder(template, base, decoration)
    }
}


// MARK: - Factories

public extension DecorationAlignment {

    static let topLeading = DecorationAlignment(x: .leading, y: .top)
    static let top = DecorationAlignment(x: .center, y: .top)
    static let topTrailing = DecorationAlignment(x: .trailing, y: .top)
    static let leading = DecorationAlignment(x: .leading, y: .center)
    static let center = DecorationAlignment(x: .center, y: .center)
    static let trailing = DecorationAlignment(x: .trailing, y: .center)
    static let bottomLeading = DecorationAlignment(x: .leading, y: .bottom)
    static let bottom = DecorationAlignment(x: .center, y: .bottom)
    static let bottomTrailing = DecorationAlignment(x: .trailing, y: .bottom)

    static let topLeft = DecorationAlignment(x: .left, y: .top)
    static let topRight = DecorationAlignment(x: .right, y: .top)
    static let left = DecorationAlignment(x: .left, y: .center)
    static let right = DecorationAlignment(x: .right, y: .center)
    static let bottomLeft = DecorationAlignment(x: .left, y: .bottom)
    static let bottomRight = DecorationAlignment(x: .right, y: .bottom)

    static let fill = DecorationAlignment(x: .center, y: .center) { template, base, decoration in
        [
            base.centerXAnchor.constraint(equalTo: decoration.centerXAnchor, constant: -template.offset.width),
            base.centerYAnchor.constraint(equalTo: decoration.centerYAnchor, constant: -template.offset.height),
            base.widthAnchor.constraint(equalTo: decoration.widthAnchor),
            base.heightAnchor.constraint(equalTo: decoration.heightAnchor),
        ]
    }
}


// MARK: - Factory for complex alignments

public extension DecorationAlignment {

    enum XPosition {
        case left, center, right, leading, trailing

        fileprivate var keyPath: KeyPath<UIView, NSLayoutXAxisAnchor> {
            switch self {
            case .left: \.leftAnchor
            case .center: \.centerXAnchor
            case .right: \.rightAnchor
            case .leading: \.leadingAnchor
            case .trailing: \.trailingAnchor
            }
        }
    }

    enum YPosition {
        case top, center, bottom
        fileprivate var keyPath: KeyPath<UIView, NSLayoutYAxisAnchor> {
            switch self {
            case .top: \.topAnchor
            case .center: \.centerYAnchor
            case .bottom: \.bottomAnchor
            }
        }
    }
}


// MARK: - Fluent builder

public extension DecorationAlignment {

    static func align(x baseX: XPosition, y baseY: YPosition) -> DecorationAlignment {
        DecorationAlignment(x: baseX, y: baseY)
    }

    func toDecoration(x: XPosition? = nil, y: YPosition? = nil) -> DecorationAlignment {
        var result = self
        if let x {
            result.template.decorationX = x
        }
        if let y {
            result.template.decorationY = y
        }
        return result
    }

    func offsetBy(x: CGFloat = 0, y: CGFloat = 0) -> DecorationAlignment {
        var result = self
        result.template.offset.width = x
        result.template.offset.height = y
        return result
    }

    func offsetBy(_ size: CGSize) -> DecorationAlignment {
        var result = self
        result.template.offset = size
        return result
    }
}
