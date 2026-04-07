import CoreGraphics
import UIKit


public extension UIColor {

    typealias PatternFactory = (CGContext, CGRect) -> Void

    convenience init?(patternSize: CGSize, pattern patternFactory: @escaping PatternFactory) {
        // Create callbacks that fetch and invoke patternFactory
        var callbacks = CGPatternCallbacks(
            version: 0,
            drawPattern: { info, context in
                let bounds = context.boundingBoxOfClipPath
                let isBoundsValid = bounds.size != .zero && bounds.width < .greatestFiniteMagnitude && bounds.height < .greatestFiniteMagnitude
                guard isBoundsValid else {
                    return
                }

                if let info {
                    let box = Unmanaged<PatternBox>.fromOpaque(info).takeUnretainedValue()
                    box.patternFactory(context, bounds)
                }
            },
            releaseInfo: { info in
                if let info {
                    Unmanaged<PatternBox>.fromOpaque(info).release()
                }
            }
        )

        // Prepare the pattern
        let patternBox = PatternBox(patternFactory: patternFactory)

        guard let pattern = CGPattern(
            info: Unmanaged.passRetained(patternBox).toOpaque(),
            bounds: CGRect(origin: .zero, size: patternSize),
            matrix: .identity,
            xStep: patternSize.width,
            yStep: patternSize.height,
            tiling: .noDistortion,
            isColored: true,
            callbacks: &callbacks
        ) else { return nil }

        let patternSpace = CGColorSpace(patternBaseSpace: nil)!
        guard let cgColor = CGColor(patternSpace: patternSpace, pattern: pattern, components: [1.0]) else {
            return nil
        }

        self.init(cgColor: cgColor)
    }
}


// MARK: - PatternBox

private class PatternBox {

    let patternFactory: UIColor.PatternFactory

    init(patternFactory: @escaping UIColor.PatternFactory) {
        self.patternFactory = patternFactory
    }
}

