import Foundation


// MARK: - View

public typealias Control = _Control & ViewBodyProvider & ViewStateHosting


extension UIControl.Event {

    static var controlDidChangeState: Self { _Control.stateDidChangeEvent }
}


// MARK: - Implementation

open class _Control: UIControl {

    // MARK: Properties

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


    // MARK: Instance life cycle

    public init() {
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
