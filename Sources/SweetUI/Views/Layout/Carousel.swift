import UIKit


public final class Carousel: UIView {

    // MARK: Types

    public protocol Delegate: AnyObject {
        func carousel(_ carousel: Carousel, didChangeSelectedItemIndex selectedItemIndex: Int?)
    }


    // MARK: Properties

    public weak var delegate: Delegate?
    public var items: [UIView] {
        didSet { updateItemsStack() }
    }
    public let spacing: CGFloat
    public let itemWidth: CGFloat?
    public let inset: CGFloat
    public let alignment: HStack.Alignment
    public private(set) var selectedItemIndex: Int? {
        didSet {
            let didChange = selectedItemIndex != oldValue
            if didChange {
                delegate?.carousel(self, didChangeSelectedItemIndex: selectedItemIndex)
            }
        }
    }
    public var selectedItem: UIView? { selectedItemIndex.flatMap { items[$0] } }


    // MARK: Views

    private lazy var itemsStack = HStack(distribution: .fillEqually, alignment: alignment, spacing: 0)

    private lazy var scrollView = CarouselScrollView(axes: .horizontal, delegate: self) {
        itemsStack
    }
        .showsHorizontalScrollIndicator(false)
        .pagingEnabled(true)
        .clipsToBounds(false)


    // MARK: Instance life cycle

    public init(inset: CGFloat = 0, itemWidth: CGFloat? = nil, spacing: CGFloat = 0, alignment: HStack.Alignment = .fill, items: [UIView] = []) {
        let items = items
        self.items = items
        self.spacing = spacing
        self.itemWidth = itemWidth
        self.inset = inset
        self.alignment = alignment
        super.init(frame: .zero)

        // Configure views
        clipsToBounds = true
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        if let itemWidth {
            NSLayoutConstraint.activate([
                scrollView.frameLayoutGuide.leadingAnchor.constraint(equalTo: leadingAnchor, constant: (inset)),
                scrollView.frameLayoutGuide.widthAnchor.constraint(equalToConstant: itemWidth + spacing),
                scrollView.frameLayoutGuide.topAnchor.constraint(equalTo: topAnchor),
                scrollView.frameLayoutGuide.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
        } else {
            NSLayoutConstraint.activate([
                scrollView.frameLayoutGuide.leadingAnchor.constraint(equalTo: leadingAnchor, constant: (inset)),
                scrollView.frameLayoutGuide.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(inset + spacing)),
                scrollView.frameLayoutGuide.topAnchor.constraint(equalTo: topAnchor),
                scrollView.frameLayoutGuide.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
        }
        updateItemsStack()

        self.scrollView.touchesDidEndHandler = { [weak self] in
            self?.setSelectedItemIndexFromCurrentItem()
        }
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: Accessors

    public func setSelectedItemIndex(_ itemIndex: Int?, animated: Bool) {
        let isChange = selectedItemIndex != itemIndex
        guard isChange else { return }
        self.selectedItemIndex = itemIndex
        setContentOffsetToShowItem(at: itemIndex, animated: animated)
    }


    // MARK: View life cycle

    private func updateItemsStack() {
        for stale in itemsStack.arrangedSubviews { stale.removeFromSuperview() }

        let paddedItems = items.map { $0.padding(leading: spacing) }
        for item in paddedItems {
            itemsStack.addArrangedSubview(item)
        }
        if let itemWidth {
            NSLayoutConstraint.activate(
                items.map {
                    $0.widthAnchor.constraint(equalToConstant: itemWidth)
                }
            )
        } else {
            NSLayoutConstraint.activate(
                items.map {
                    $0.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -spacing)
                }
            )
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        setContentOffsetToShowItem(at: selectedItemIndex, animated: false)
    }


    // MARK: Event handling

    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Point can be outside of the self's bounds, which is surprising.
        let isInBounds = bounds.contains(point)
        guard isInBounds else { return nil }

        let superResult = super.hitTest(point, with: event)
        if superResult != self {
            return superResult
        }

        // We've messed up the scrollView's hitTest because of clipToBounds and frame manipulations
        // so we manually find its subviews.
        let pointInScrollViewCoordinateSpace = scrollView.convert(point, from: self)
        let hitSubviews: [UIView] = scrollView.subviews
            .filter { $0.frame.contains(pointInScrollViewCoordinateSpace) }
        let zIndexAndSubviewPairs: [(zIndex: Int, subview: UIView)] = hitSubviews.compactMap { subview in
            guard let zIndex = scrollView.subviews.firstIndex(of: subview) else { return nil }
            return (zIndex: zIndex, subview: subview)
        }
        let subviewsByZIndex = Dictionary(uniqueKeysWithValues: zIndexAndSubviewPairs)
        let subview = subviewsByZIndex.keys.max().flatMap { subviewsByZIndex[$0] }
        if let subview {
            let pointInSubviewCoordinateSpace = subview.convert(point, from: self)
            return subview.hitTest(pointInSubviewCoordinateSpace, with: event)
        }
        return scrollView.hitTest(pointInScrollViewCoordinateSpace, with: event)
    }
}


// MARK: - Offset management

private extension Carousel {

    // This does not set selectedItemIndex
    func setContentOffsetToShowItem(at itemIndex: Int?, animated: Bool) {
        guard let itemIndex, itemIndex > -1, itemIndex < items.count else { return }
        guard window != nil else { return }

        scrollView.layoutIfNeeded()
        let item = items[itemIndex]
        let paddedItem = item.superview ?? item // Default should never be needed
        let unboundOffset = paddedItem.convert(paddedItem.bounds.origin, to: scrollView)
        let maxOffset = maxOffset()
        let offset = CGPoint(
            x: min(unboundOffset.x, maxOffset.x),
            y: unboundOffset.y
        )
        scrollView.setContentOffset(offset, animated: animated)
    }

    func indexOfCurrentItem() -> Int? {
        let referenceX = scrollView.contentOffset.x
        for (index, item) in items.enumerated() {
            let paddedItem = item.superview ?? item // Default shouldn't be needed
            let normalizedFrame = paddedItem.convert(paddedItem.bounds, to: scrollView)
            let isFirstVisibleItem = normalizedFrame.minX <= referenceX && normalizedFrame.maxX > referenceX
            if isFirstVisibleItem {
                return index
            }
        }
        return nil
    }

    func setSelectedItemIndexFromCurrentItem() {
        if let itemIndex = indexOfCurrentItem() {
            let hasChanged = selectedItemIndex != itemIndex
            if hasChanged {
                selectedItemIndex = itemIndex
            }
        }
    }

    func maxOffset() -> CGPoint {
        let defaultPoint = CGPoint(x: CGFloat.greatestFiniteMagnitude, y: 0)
        "return defaultPoint"
        guard let lastItem = items.last else { return defaultPoint }
        let lastItemFrame = scrollView.convert(lastItem.bounds, from: lastItem)
        let maxContentPoint = CGPoint(
            x: lastItemFrame.maxX + spacing,
            y: lastItemFrame.minY
        )
        let distanceBetweenOffsetAndRightEdge = self.bounds.width - (inset + spacing)
        let unquantizedMaxOffsetX = maxContentPoint.x - distanceBetweenOffsetAndRightEdge
        let itemOrigins = items.map { scrollView.convert($0.bounds.origin, from: $0) }
        let maxOffset = itemOrigins.last { $0.x <= unquantizedMaxOffsetX }
        return maxOffset ?? defaultPoint
    }
}


// MARK: - UIScrollViewDelegate

extension Carousel: UIScrollViewDelegate {

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        setSelectedItemIndexFromCurrentItem()
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setSelectedItemIndexFromCurrentItem()
    }
}


// MARK: - CarouselScrollView

private class CarouselScrollView<Content: UIView>: ScrollView<Content> {

    var touchesDidEndHandler: (() -> Void)?

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        touchesDidEndHandler?()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        touchesDidEndHandler?()
    }
}


// MARK: - Factories

public extension Carousel {

    convenience init(inset: CGFloat = 0, itemWidth: CGFloat? = nil, spacing: CGFloat = 0, alignment: HStack.Alignment = .fill, @SubviewsBuilder items itemsBuilder: () -> [UIView]) {
        self.init(inset: inset, itemWidth: itemWidth, spacing: spacing, alignment: alignment, items: itemsBuilder())
    }
}
