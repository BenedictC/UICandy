import UIKit


public final class ZStack: UIView {

    // MARK: Properties

    public let alignment: ContentAlignment
    public private(set) var arrangedSubviews = [UIView]()


    // MARK: Instance life cycle

    public init(alignment: ContentAlignment = .fill) {
        self.alignment = alignment
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: Subview management

    public func addArrangedSubview(_ subview: UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        arrangedSubviews.append(subview)
        constrain(subview: subview)
        // TODO: Add debug warning for when:
        // - a subview is added with huggingPriority equal or greater than the other subviews' compressionResistance
    }

    public override func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)

        if let index = arrangedSubviews.firstIndex(of: subview) {
            arrangedSubviews.remove(at: index)
        }
    }
}


// MARK: - Sub view constraining

private extension ZStack {

    enum AnchorKind {
        case absolute, directional
    }

    struct Anchors {
        let top: NSLayoutYAxisAnchor
        let left: NSLayoutXAxisAnchor
        let bottom: NSLayoutYAxisAnchor
        let right: NSLayoutXAxisAnchor
        let centerX: NSLayoutXAxisAnchor
        let centerY: NSLayoutYAxisAnchor
    }

    func constrain(subview: UIView) {
        let constraints: [NSLayoutConstraint]
        switch alignment {
        case .fill: constraints = constrain(subview: subview, pinnedTo: .all, centerAxis: .none, anchorKind: .absolute)

        case .topLeft: constraints = constrain(subview: subview, pinnedTo: [.top, .left], centerAxis: .none, anchorKind: .absolute)
        case .top: constraints = constrain(subview: subview, pinnedTo: [.top], centerAxis: .horizontal, anchorKind: .absolute)
        case .topRight: constraints = constrain(subview: subview, pinnedTo: [.top, .right], centerAxis: .none, anchorKind: .absolute)
        case .left: constraints = constrain(subview: subview, pinnedTo: [.left], centerAxis: .vertical, anchorKind: .absolute)
        case .center: constraints = constrain(subview: subview, pinnedTo: [], centerAxis: .both, anchorKind: .absolute)
        case .right: constraints =  constrain(subview: subview, pinnedTo: [.right], centerAxis: .vertical, anchorKind: .absolute)
        case .bottomLeft: constraints = constrain(subview: subview, pinnedTo: [.bottom, .left], centerAxis: .none, anchorKind: .absolute)
        case .bottom: constraints = constrain(subview: subview, pinnedTo: [.bottom], centerAxis: .horizontal, anchorKind: .absolute)
        case .bottomRight: constraints = constrain(subview: subview, pinnedTo: [.bottom, .right], centerAxis: .none, anchorKind: .absolute)

        case .topLeading: constraints = constrain(subview: subview, pinnedTo: [.top, .left], centerAxis: .none, anchorKind: .directional)
        case .topTrailing: constraints = constrain(subview: subview, pinnedTo: [.top, .right], centerAxis: .none, anchorKind: .directional)
        case .leading: constraints = constrain(subview: subview, pinnedTo: [.left], centerAxis: .vertical, anchorKind: .directional)
        case .trailing: constraints = constrain(subview: subview, pinnedTo: [.right], centerAxis: .vertical, anchorKind: .directional)
        case .bottomLeading: constraints = constrain(subview: subview, pinnedTo: [.bottom, .left], centerAxis: .none, anchorKind: .directional)
        case .bottomTrailing: constraints = constrain(subview: subview, pinnedTo: [.bottom, .right], centerAxis: .none, anchorKind: .directional)
        }
        NSLayoutConstraint.activate(constraints)
    }

    func constrain(subview: UIView, pinnedTo pinnedEdges: UIRectEdge, centerAxis: Axis, anchorKind: AnchorKind) -> [NSLayoutConstraint] {
        // Fetch anchors
        let subviewAnchors: Anchors
        let selfAnchors: Anchors
        switch anchorKind {
        case .absolute:
            selfAnchors = absoluteAnchors(for: subview)
            subviewAnchors = Anchors(top: subview.topAnchor, left: subview.leftAnchor, bottom: subview.bottomAnchor, right: subview.rightAnchor, centerX: subview.centerXAnchor, centerY: subview.centerYAnchor)
        case .directional:
            selfAnchors = directionalAnchors(for: subview)
            subviewAnchors = Anchors(top: subview.topAnchor, left: subview.leadingAnchor, bottom: subview.bottomAnchor, right: subview.trailingAnchor, centerX: subview.centerXAnchor, centerY: subview.centerYAnchor)
        }

        // Required constraints
        let fillVertically = intrinsicallyFills(axis: .vertical, view: subview)
        let top = fillVertically || pinnedEdges.contains(.top)
        ? subviewAnchors.top.constraint(equalTo: selfAnchors.top)
        : subviewAnchors.top.constraint(greaterThanOrEqualTo: selfAnchors.top)
        let bottom = fillVertically || pinnedEdges.contains(.bottom)
        ? subviewAnchors.bottom.constraint(equalTo: selfAnchors.bottom)
        : subviewAnchors.bottom.constraint(lessThanOrEqualTo: selfAnchors.bottom)

        let fillHorizontally = intrinsicallyFills(axis: .horizontal, view: subview)
        let left = fillHorizontally || pinnedEdges.contains(.left)
        ? subviewAnchors.left.constraint(equalTo: selfAnchors.left)
        : subviewAnchors.left.constraint(greaterThanOrEqualTo: selfAnchors.left)
        let right = fillHorizontally || pinnedEdges.contains(.right)
        ? subviewAnchors.right.constraint(equalTo: selfAnchors.right)
        : subviewAnchors.right.constraint(lessThanOrEqualTo: selfAnchors.right)

        var constraints = [top, bottom, left, right]


        // Optional constraints
        if centerAxis.contains(.horizontal) {
            constraints += [subviewAnchors.centerX.constraint(equalTo: selfAnchors.centerX)]
        }
        if centerAxis.contains(.vertical) {
            constraints += [subviewAnchors.centerY.constraint(equalTo: selfAnchors.centerY)]
        }

        return constraints
    }

    func sizingScrollView(for view: UIView) -> UIScrollView? {
        if let view = view as? UIScrollView {
            return view
        }
        return view.subviews.first.flatMap { self.sizingScrollView(for: $0) }
    }

    func intrinsicallyFills(axis: Axis, view: UIView) -> Bool {
        // If the view is explicitly IntrinsicFillSupporting then we're done
        if let view = view as? ZStackFillBehaviourSupporting {
            return view.zStackFillAxes.contains(axis)
        }
        // Else we infer it from the rest of the hierarchy
        let isMatch = Self.fillsZStack(axis: axis, view: view)
        let isFirstChildMatch = { !view.subviews.isEmpty && self.intrinsicallyFills(axis: axis, view: view.subviews[0]) }
        return isMatch || isFirstChildMatch()
    }

    func absoluteAnchors(for subview: UIView) -> Anchors {
        let edgesIgnoringSafeArea = Self.edgesIgnoringSafeArea(for: subview)
        let topAnchor = edgesIgnoringSafeArea.contains(.top) ? self.topAnchor : self.safeAreaLayoutGuide.topAnchor
        let bottomAnchor = edgesIgnoringSafeArea.contains(.bottom) ? self.bottomAnchor : self.safeAreaLayoutGuide.bottomAnchor
        let leftAnchor = edgesIgnoringSafeArea.contains(.left) ? self.leftAnchor : self.safeAreaLayoutGuide.leftAnchor
        let rightAnchor = edgesIgnoringSafeArea.contains(.right) ? self.rightAnchor : self.safeAreaLayoutGuide.rightAnchor
        let (centerXAnchor, centerYAnchor) = centerAnchorsForConstraining(subview: subview, edgesIgnoringSafeArea: edgesIgnoringSafeArea)

        return Anchors(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, centerX: centerXAnchor, centerY: centerYAnchor)
    }

    func directionalAnchors(for subview: UIView) -> Anchors {
        let edgesIgnoringSafeArea = Self.edgesIgnoringSafeArea(for: subview)
        let topAnchor = edgesIgnoringSafeArea.contains(.top) ? self.topAnchor : self.safeAreaLayoutGuide.topAnchor
        let bottomAnchor = edgesIgnoringSafeArea.contains(.bottom) ? self.bottomAnchor : self.safeAreaLayoutGuide.bottomAnchor
        let leftAnchor = edgesIgnoringSafeArea.contains(.left) ? self.leadingAnchor : self.safeAreaLayoutGuide.leadingAnchor
        let rightAnchor = edgesIgnoringSafeArea.contains(.right) ? self.trailingAnchor : self.safeAreaLayoutGuide.trailingAnchor
        let (centerXAnchor, centerYAnchor) = centerAnchorsForConstraining(subview: subview, edgesIgnoringSafeArea: edgesIgnoringSafeArea)

        return Anchors(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, centerX: centerXAnchor, centerY: centerYAnchor)
    }

    func centerAnchorsForConstraining(subview: UIView, edgesIgnoringSafeArea: UIRectEdge) -> (x: NSLayoutXAxisAnchor, y: NSLayoutYAxisAnchor) {
        let ignoresHorizontalEdge = edgesIgnoringSafeArea.contains(.left) || edgesIgnoringSafeArea.contains(.right)
        let centerXAnchor = ignoresHorizontalEdge ? self.centerXAnchor : self.safeAreaLayoutGuide.centerXAnchor
        let ignoresVerticalEdge = edgesIgnoringSafeArea.contains(.top) || edgesIgnoringSafeArea.contains(.bottom)
        let centerYAnchor = ignoresVerticalEdge ? self.centerYAnchor : self.safeAreaLayoutGuide.centerYAnchor
        return (x: centerXAnchor, y: centerYAnchor)
    }
}


// MARK: - Result builder init

public extension ZStack {

    convenience init(alignment: ContentAlignment = .fill,  @SubviewsBuilder arrangedSubviewsBuilder: () -> [UIView]) {
        self.init(alignment: alignment)

        let arrangedSubviews = arrangedSubviewsBuilder()
        arrangedSubviews.forEach { self.addArrangedSubview($0) }
    }
}
