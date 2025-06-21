import Foundation
import UIKit


public typealias View = _View & ViewBodyProvider & ViewStateHosting


// MARK: - Implementation

open class _View: UIView {

    // MARK: Properties

    public lazy var viewStateObservations = [ViewStateObservation]()


    // MARK: Instance life cycle
    
    public init() {
        super.init(frame: .zero)
        Self.initializeBodyHosting(of: self)
        (self as? ViewStateHosting)?.initializeViewStateObserving()
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func layoutSubviews() {
        (self as? ViewStateHosting)?.performViewStateObservationUpdates()
        super.layoutSubviews()
    }
}


// MARK: - ViewBodyProvider

public extension _View {

    func arrangeBody(_ body: UIView, in container: UIView) {
        container.addAndFill(subview: body, overrideEdgesIgnoringSafeArea: nil)
    }
}
