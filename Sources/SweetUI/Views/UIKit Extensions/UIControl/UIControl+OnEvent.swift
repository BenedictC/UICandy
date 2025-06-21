import UIKit
import ObjectiveC


//  MARK: - On Event

@MainActor
public extension SomeView where Self: UIControl {

    func onEvent(
        _ event: UIControl.Event,
        perform handler: @escaping (Self) -> Void
    ) -> Self {
        let observation = UIControlEventObservation(
            owner: self,
            event: event,
            handler: { [weak self] in
                guard let self else { return }
                handler(self)
        })
        self.addTarget(observation, action: #selector(UIControlEventObservation.handleEvent), for: event)
        self.addEventObservation(observation)

        return self
    }

    func onEvent(
        _ event: UIControl.Event,
        observation: inout UIControlEventObservation?,
        perform handler: @escaping (Self) -> Void
    ) -> Self {
        let eventObservation = UIControlEventObservation(
            owner: self,
            event: event,
            handler: { [weak self] in
                guard let self else { return }
                handler(self)
        })
        self.addTarget(eventObservation, action: #selector(UIControlEventObservation.handleEvent), for: event)
        self.addEventObservation(eventObservation)
        observation = eventObservation

        return self
    }
}


// MARK: - UIControlEventObservation

public class UIControlEventObservation: NSObject {

    public private(set) var isCancelled = false

    weak var owner: UIControl?
    let event: UIControl.Event
    var handler: (() -> Void)?

    init(owner: UIControl, event: UIControl.Event, handler: @escaping () -> Void) {
        self.owner = owner
        self.event = event
        self.handler = handler
        super.init()
    }

    deinit {
        cancel()
    }

    @objc func handleEvent() {
        if isCancelled {
            return
        }
        handler?()
    }

    public func cancel() {
        isCancelled = true
        handler = nil
        owner?.removeTarget(self, action: #selector(handleEvent), for: event)
        owner?.removeEventObservation(self)
    }
}


// MARK: Storage (a little hacky)

private extension UIControl {

    private static var eventObservationsKey: UInt8 = 0

    var observations: [UIControlEventObservation] {
        get { objc_getAssociatedObject(self, &Self.eventObservationsKey) as! [UIControlEventObservation] }
        set { objc_setAssociatedObject(self, &Self.eventObservationsKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }

    func addEventObservation(_ observation: UIControlEventObservation) {
        observations.append(observation)
    }

    func removeEventObservation(_ observation: UIControlEventObservation) {
        observations =  observations.filter { $0 != observation }
    }
}
