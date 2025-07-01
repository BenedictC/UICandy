

public struct ViewStateObservation {

    public let identifier: AnyHashable?

    let updateHandler: () -> Bool

    func performUpdate() -> Bool {
        updateHandler()
    }
}
