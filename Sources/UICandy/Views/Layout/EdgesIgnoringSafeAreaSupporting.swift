import UIKit


public struct SafeAreaRegions: OptionSet {

    public let rawValue: Int8

    public static let all = Self(rawValue: ~0)
    public static let container = Self(rawValue: 1 << 0)
    public static let keyboard = Self(rawValue: 1 << 1)
    public static let none: Self = []

    public init(rawValue: Int8) {
        self.rawValue = rawValue
    }
}

@MainActor
public protocol EdgesIgnoringSafeAreaSupporting: UIView {
    var safeAreaIgnoringRegions: SafeAreaRegions { get }
    var edgesIgnoringSafeArea: UIRectEdge { get }
}


public extension UIRectEdge {
    static let vertical: UIRectEdge = [.top, .bottom]
    static let horizontal: UIRectEdge = [.left, .right]
}


// MARK: - Defaults

public extension EdgesIgnoringSafeAreaSupporting {

    var edgesIgnoringSafeArea: UIRectEdge {
        // We don't use type constrained extensions because a UIScrollView can be passed around as a UIView
        if self is UIScrollView {
            return .all
        }
        return []
    }

    var safeAreaIgnoringRegions: SafeAreaRegions {
        if self is UIScrollView {
            return .none
        }
        return .container
    }
}


// MARK: - Internal UIView additions

struct EdgeConstraints {
    let top: NSLayoutConstraint
    let bottom: NSLayoutConstraint
    let left: NSLayoutConstraint
    let right: NSLayoutConstraint
}

extension UIView {

    // We could replace this method by making UIView conform to EdgesIgnoringSafeAreaSupporting but
    // that would mean each view would have a property that provides next no utility.
    static func edgesIgnoringSafeArea(for view: UIView) -> UIRectEdge {
        if let view = view as? EdgesIgnoringSafeAreaSupporting {
            return view.edgesIgnoringSafeArea
        }
        if view is UIScrollView {
            return .all
        }
        if let subview = view.subviews.first {
            return edgesIgnoringSafeArea(for: subview)
        }
        return .all
    }

    @discardableResult
    func addAndFill(subview: UIView, edgesIgnoringSafeArea: UIRectEdge) -> EdgeConstraints {
        self.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false

        let topAnchor = edgesIgnoringSafeArea.contains(.top) ? self.topAnchor: self.safeAreaLayoutGuide.topAnchor
        let bottomAnchor = edgesIgnoringSafeArea.contains(.bottom) ? self.bottomAnchor: self.safeAreaLayoutGuide.bottomAnchor
        let leftAnchor = edgesIgnoringSafeArea.contains(.left) ? self.leftAnchor: self.safeAreaLayoutGuide.leftAnchor
        let rightAnchor = edgesIgnoringSafeArea.contains(.right) ? self.rightAnchor: self.safeAreaLayoutGuide.rightAnchor

        let topConstraint = subview.topAnchor.constraint(equalTo: topAnchor)
        let bottomConstraint = subview.bottomAnchor.constraint(equalTo: bottomAnchor)
        let leftConstraint = subview.leftAnchor.constraint(equalTo: leftAnchor)
        let rightConstraint = subview.rightAnchor.constraint(equalTo: rightAnchor)

        NSLayoutConstraint.activate([
            topConstraint,
            bottomConstraint,
            leftConstraint,
            rightConstraint
        ])
        return EdgeConstraints(top: topConstraint, bottom: bottomConstraint, left: leftConstraint, right: rightConstraint)
    }
}
