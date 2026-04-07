import UIKit


public final class ShapeView: UIView {

    // MARK: Types

    public struct Configuration {

        public var fillColor: UIColor?
        public var fillRule: CAShapeLayerFillRule
        public var strokeColor: UIColor?
        public var strokeStart: CGFloat
        public var strokeEnd: CGFloat
        public var lineWidth: CGFloat
        public var miterLimit: CGFloat
        public var lineCap: CAShapeLayerLineCap
        public var lineJoin: CAShapeLayerLineJoin
        public var lineDashPhase: CGFloat
        public var lineDashPattern: [NSNumber]?


        public static func make(
            fillColor: UIColor? = UIColor.black,
            fillRule: CAShapeLayerFillRule = .nonZero,
            strokeColor: UIColor? = nil,
            strokeStart: CGFloat = 0,
            strokeEnd: CGFloat = 1,
            lineWidth: CGFloat = 1, // Default not specified in the docs
            miterLimit: CGFloat = 10,
            lineCap: CAShapeLayerLineCap = .butt,
            lineJoin: CAShapeLayerLineJoin = .miter,
            lineDashPhase: CGFloat = 0,
            lineDashPattern: [NSNumber]? = nil
        ) -> Self {
            Self(
                fillColor: fillColor,
                fillRule: fillRule,
                strokeColor: strokeColor,
                strokeStart: strokeStart,
                strokeEnd: strokeEnd,
                lineWidth: lineWidth,
                miterLimit: miterLimit,
                lineCap: lineCap,
                lineJoin: lineJoin,
                lineDashPhase: lineDashPhase,
                lineDashPattern: lineDashPattern
            )
        }

        func apply(to layer: CAShapeLayer) {
            layer.fillColor = self.fillColor?.cgColor
            layer.fillRule = self.fillRule
            layer.strokeColor = self.strokeColor?.cgColor
            layer.strokeStart = self.strokeStart
            layer.strokeEnd = self.strokeEnd
            layer.lineWidth = self.lineWidth
            layer.miterLimit = self.miterLimit
            layer.lineCap = self.lineCap
            layer.lineJoin = self.lineJoin
            layer.lineDashPhase = self.lineDashPhase
            layer.lineDashPattern = self.lineDashPattern
        }
    }


    // MARK: Properties

    public override static var layerClass: AnyClass { CAShapeLayer.self }

    public var configuration: Configuration {
        didSet { setNeedsLayout() }
    }
    public let drawingActions: (CAShapeLayer) -> Void


    // MARK: Instance life cycle

    public init(configuration: Configuration, drawingActions: @escaping (CAShapeLayer) -> Void) {
        self.configuration = configuration
        self.drawingActions = drawingActions
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: Layout

    public override func layoutSubviews() {
        super.layoutSubviews()
        if let layer = layer as? CAShapeLayer {
            configuration.apply(to: layer)
            drawingActions(layer)
        }
    }
}


// MARK: - Factories

public extension ShapeView {

    static func roundedRect(
        cornerRadius: CGFloat = .greatestFiniteMagnitude,
        configuration: Configuration = .make()
    ) -> ShapeView {
        ShapeView(
            configuration: configuration,
            drawingActions: { layer in
                let boundsCornerRadius = min(layer.bounds.width, layer.bounds.height)
                let finalCornerRadius = min(boundsCornerRadius, cornerRadius)
                let path = UIBezierPath(roundedRect: layer.bounds, cornerRadius: finalCornerRadius)
                layer.path = path.cgPath
            }
        )
    }

    static func capsule(
        configuration: Configuration = .make()
    ) -> ShapeView {
        ShapeView.roundedRect(configuration: configuration)
    }

    static func circle(
        configuration: Configuration = .make()
    ) -> ShapeView {
        ShapeView(
            configuration: configuration,
            drawingActions: { layer in
                let smallestDimension = min(layer.bounds.width, layer.bounds.height)
                let oval = CGRect(
                    x: (layer.bounds.width - smallestDimension) * 0.5,
                    y: (layer.bounds.height - smallestDimension) * 0.5,
                    width: smallestDimension,
                    height: smallestDimension
                )
                let path = UIBezierPath(ovalIn: oval)
                layer.path = path.cgPath
            }
        )
    }

    static func ellipse(
        configuration: Configuration = .make()
    ) -> ShapeView {
        ShapeView(
            configuration: configuration,
            drawingActions: { layer in
                let path = UIBezierPath(ovalIn: layer.bounds)
                layer.path = path.cgPath
            }
        )
    }

    static func rectangle(
        configuration: Configuration = .make()
    ) -> ShapeView {
        ShapeView(
            configuration: configuration,
            drawingActions: { layer in
                let path = UIBezierPath(rect: layer.bounds)
                layer.path = path.cgPath
            }
        )
    }
}
