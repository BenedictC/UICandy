import UIKit


// MARK: - Linear Gradient

public extension UIColor {

    convenience init?(
        linearGradient gradient: CGGradient,
        start: ContentPoint,
        end: ContentPoint,
        options: CGGradientDrawingOptions = [.drawsBeforeStartLocation, .drawsAfterEndLocation]
    ) {
        let screenSize = UIScreen.main.bounds.size
        let largestDimension = max(screenSize.width, screenSize.height)
        let patternSize = CGSize(width: largestDimension, height: largestDimension)
        self.init(patternSize: patternSize, pattern: { context, bounds in
            let start = start.point(in: bounds)
            let end = end.point(in: bounds)
            context.drawLinearGradient(
                gradient,
                start: start,
                end: end,
                options: options
            )
        })
    }

    static func linearGradient(colors: [UIColor], start: ContentPoint, end: ContentPoint) -> UIColor {
        guard
            let gradient = CGGradient.make(colors: colors, colorSpace: nil),
            let color = UIColor(linearGradient: gradient, start: start, end: end) else {
            return .systemBackground
        }
        return color
    }

    static func linearGradient(stops: [GradientStop], start: ContentPoint, end: ContentPoint) -> UIColor {
        guard
            let gradient = CGGradient.make(stops: stops, colorSpace: nil),
            let color = UIColor(linearGradient: gradient, start: start, end: end) else {
            return .systemBackground
        }
        return color
    }
}


// MARK: - Radial Gradient

public extension UIColor {

    convenience init?(
        radialGradient gradient: CGGradient,
        startCenter: ContentPoint,
        startRadius: CGFloat,
        endCenter: ContentPoint? = nil,
        endRadius: CGFloat,
        options: CGGradientDrawingOptions = [.drawsBeforeStartLocation, .drawsAfterEndLocation]
    ) {
        let screenSize = UIScreen.main.bounds.size
        let largestDimension = max(screenSize.width, screenSize.height)
        let patternSize = CGSize(width: largestDimension, height: largestDimension)
        self.init(patternSize: patternSize, pattern: { context, bounds in
            let start = startCenter.point(in: bounds)
            let end = (endCenter ?? startCenter).point(in: bounds)
            context.drawRadialGradient(
                gradient,
                startCenter: start,
                startRadius: startRadius,
                endCenter: end,
                endRadius: endRadius,
                options: options
            )
        })
    }

    static func radialGradient(
        colors: [UIColor],
        startCenter: ContentPoint = .center,
        startRadius: CGFloat,
        endCenter: ContentPoint? = nil,
        endRadius: CGFloat
    ) -> UIColor {
        guard
            let gradient = CGGradient.make(colors: colors, colorSpace: nil),
            let color = UIColor(radialGradient: gradient, startCenter: startCenter, startRadius: startRadius, endCenter: endCenter, endRadius: endRadius) else {
            return .systemBackground
        }
        return color
    }

    static func radialGradient(
        stops: [GradientStop],
        startCenter: ContentPoint = .center,
        startRadius: CGFloat,
        endCenter: ContentPoint? = nil,
        endRadius: CGFloat
    ) -> UIColor {
        guard
            let gradient = CGGradient.make(stops: stops, colorSpace: nil),
            let color = UIColor(radialGradient: gradient, startCenter: startCenter, startRadius: startRadius, endCenter: endCenter, endRadius: endRadius) else {
            return .systemBackground
        }
        return color
    }
}

