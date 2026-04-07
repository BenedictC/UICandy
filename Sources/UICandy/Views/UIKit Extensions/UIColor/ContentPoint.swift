import UIKit


public enum ContentPoint {
    case topLeft, top, topRight
    case left, center, right
    case bottomLeft, bottom, bottomRight

    case topLeading, topTrailing
    case leading, trailing
    case bottomLeading, bottomTrailing


    public func point(
        in rect: CGRect,
        userInterfaceLayoutDirection: UIUserInterfaceLayoutDirection = UIApplication.shared.userInterfaceLayoutDirection
    ) -> CGPoint {
        let x: CGFloat = switch self {
        case .topLeft, .left, .bottomLeft:
            rect.minX
        case .top, .center, .bottom:
            rect.midX
        case .topRight, .right, .bottomRight:
            rect.maxX

        case .topLeading, .leading, .bottomLeading:
            switch userInterfaceLayoutDirection {
            case .leftToRight: rect.minX
            case .rightToLeft: rect.maxX
            @unknown default: rect.minX
            }
        case .topTrailing, .trailing, .bottomTrailing:
            switch userInterfaceLayoutDirection {
            case .leftToRight: rect.maxX
            case .rightToLeft: rect.minX
            @unknown default: rect.maxX
            }
        }

        let y: CGFloat = switch self {
        case .topLeft, .top, .topRight, .topLeading, .topTrailing:
            rect.maxY

        case .left, .center, .right, .leading, .trailing:
            rect.midY

        case .bottomLeft, .bottom, .bottomRight, .bottomLeading, .bottomTrailing:
            rect.minY
        }

        return CGPoint(x: x, y: y)
    }
}
