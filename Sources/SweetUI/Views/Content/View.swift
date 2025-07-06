import Foundation
import UIKit


public typealias View = _View & ViewBodyProvider & ViewStateHosting


// MARK: - Implementation

open class _View: UIView {

    // MARK: Properties

    private lazy var onUpdatePropertiesHandlers = Set<OnUpdatePropertiesHandler>()


    // MARK: Instance life cycle
    
    public init() {
        super.init(frame: .zero)
        Self.initializeBodyHosting(of: self)
        (self as? ViewStateHosting)?.initializeViewStateHosting()
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
}


// MARK: - ViewBodyProvider

public extension _View {

    func arrangeBody(_ body: UIView, in container: UIView) {
        container.addAndFill(subview: body, overrideEdgesIgnoringSafeArea: nil)
    }
}
