import Foundation


// MARK: - View

public typealias Control = _Control & ViewBodyProvider & ViewStateHosting


extension UIControl.Event {

    static var controlDidChangeState: Self { _Control.stateDidChangeEvent }
}


// MARK: - Implementation

open class _Control: UIControl {

    // MARK: Types

    public typealias HitTestHandler = (_ body: UIView, _ point: CGPoint, _ event: UIEvent?) -> UIView?


    // MARK: Properties

    public var hitTestHandler: HitTestHandler
    /// Value used to notify of state changes via sendAction. Change this value if the default conflicts with an existing application value
    // The following values are available for application use: 1 << 24, 1 << 25, 1 << 26, and 1 << 27
    public static var stateDidChangeEvent = UIControl.Event(rawValue: 1 << 24)

    open override var isEnabled: Bool {
        get { super.isEnabled }
        set { super.isEnabled = newValue; notifyOfStateChange() }
    }
    open override var isSelected: Bool {
        get { super.isSelected }
        set { super.isSelected = newValue; notifyOfStateChange() }
    }
    open override var isHighlighted: Bool {
        get { super.isHighlighted }
        set { super.isHighlighted = newValue; notifyOfStateChange() }
    }
    open override var isHidden: Bool {
        get { super.isHidden }
        set { super.isHidden = newValue; notifyOfStateChange() }
    }

    private lazy var onUpdatePropertiesHandlers = Set<OnUpdatePropertiesHandler>()


    // MARK: Instance life cycle

    public init() {
        self.hitTestHandler = Self.makeDefaultHitTestProvider()
        super.init(frame: .zero)
        UIView.initializeBodyHosting(of: self)
        (self as? ViewStateHosting)?.initializeViewStateHosting()
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: Touch handling

    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let result = super.beginTracking(touch, with: event)
        notifyOfStateChange()
        return result
    }

    open override func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)
        notifyOfStateChange()
    }

    open override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        notifyOfStateChange()
    }


    // MARK: Hit Testing

    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let bodyProvider = self as? (any ViewBodyProvider) else {
            return super.hitTest(point, with: event)
        }
        let body = bodyProvider.body

        let bodyPoint = convert(point, to: body)
        if let subview = hitTestHandler(body, bodyPoint, event) {
            return subview
        }
        let isInBounds = bounds.contains(point)
        return isInBounds ? self : nil
    }

    public static func makeDefaultHitTestProvider() -> HitTestHandler {
        return { body, point, event in
            guard let subview = body.hitTest(point, with: event) else {
                return nil
            }
            let isControl = subview is UIControl
            let hasEnabledRecognizers = subview.gestureRecognizers?.contains { $0.isEnabled } ?? false
            let shouldUseSubview = isControl || hasEnabledRecognizers
            return shouldUseSubview ? subview : nil
        }
    }


    // MARK: View State

    public func addOnUpdatePropertiesHandler(withIdentifier identifier: AnyHashable?, action: @escaping () -> Void) {
        let handler = OnUpdatePropertiesHandler(identifier: identifier, handler: action)
        onUpdatePropertiesHandlers.insert(handler)
    }

    public func removeOnUpdatePropertiesHandler(withIdentifier identifier: AnyHashable) {
        onUpdatePropertiesHandlers = onUpdatePropertiesHandlers.filter { $0.identifier != identifier }
    }


    // MARK: Layout

    override open func layoutSubviews() {
        // TODO: Add iOS 26 support
        for handler in onUpdatePropertiesHandlers {
            handler.execute()
        }
        super.layoutSubviews()
    }

    
    // MARK: State management

    private func notifyOfStateChange() {
        sendActions(for: Self.stateDidChangeEvent)
    }
}


// MARK: - ViewBodyProvider

public extension _Control {

    func arrangeBody(_ body: UIView, in container: UIView) {
        container.addAndFill(subview: body, overrideEdgesIgnoringSafeArea: nil)
    }
}
