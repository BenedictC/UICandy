import Foundation
import Combine
import UIKit


// MARK: - View

public typealias Control = _Control & ViewBodyProvider


// MARK: - Implementation

open class _Control: UIControl {

    // MARK: Properties

    override open var isEnabled: Bool {
        get { super.isEnabled }
        set { super.isEnabled = newValue; notifyOfStateChange() }
    }
    override open var isSelected: Bool {
        get { super.isSelected }
        set { super.isSelected = newValue; notifyOfStateChange() }
    }
    override open var isHighlighted: Bool {
        get { super.isHighlighted }
        set { super.isHighlighted = newValue; notifyOfStateChange() }
    }
    override open var isHidden: Bool {
        get { super.isHidden }
        set { super.isHidden = newValue; notifyOfStateChange() }
    }


    // MARK: Instance life cycle

    public init() {
        super.init(frame: .zero)
        UIView.initializeBodyHosting(of: self)
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: View events

    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let result = super.beginTracking(touch, with: event)
        notifyOfStateChange()
        return result
    }

    public override func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)
        notifyOfStateChange()
    }

    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        notifyOfStateChange()
    }


    // MARK: State management

    private func notifyOfStateChange() {
        _stateChanges = state
    }
}


// MARK: - ViewBodyProvider

public extension _Control {

    func arrangeBody(_ body: UIView, in container: UIView) {
        container.addAndFill(subview: body, overrideEdgesIgnoringSafeArea: nil)
    }
}
