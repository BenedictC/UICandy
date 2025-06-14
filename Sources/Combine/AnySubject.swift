import Combine


internal final class AnySubject<Output, Failure: Error>: Subject {

    // MARK: Types

    typealias Output = Output
    typealias Failure = Failure


    // MARK: Properties

    let receiveHandler: (AnySubscriber<Output, Failure>) -> Void
    let sendValueHandler: (Output) -> Void
    let sendCompletionHandler: (Subscribers.Completion<Failure>) -> Void
    let sendSubscriptionHandler: (Subscription) -> Void


    // MARK: Instance life cycle

    init(
        receiveHandler: @escaping (AnySubscriber<Output, Failure>) -> Void,
        sendValueHandler: @escaping (Output) -> Void,
        sendCompletionHandler: @escaping (Subscribers.Completion<Failure>) -> Void,
        sendSubscriptionHandler: @escaping (Subscription) -> Void)
    {
        self.receiveHandler = receiveHandler
        self.sendValueHandler = sendValueHandler
        self.sendCompletionHandler = sendCompletionHandler
        self.sendSubscriptionHandler = sendSubscriptionHandler
    }


    // MARK: Subject

    func receive(subscriber: some Subscriber<Output, Failure>) {
        let anySubscriber = AnySubscriber(subscriber)
        receiveHandler(anySubscriber)
    }

    func send(_ value: Output) {
        sendValueHandler(value)
    }

    func send(completion: Subscribers.Completion<Failure>) {
        sendCompletionHandler(completion)
    }

    func send(subscription: Subscription) {
        sendSubscriptionHandler(subscription)
    }
}


// MARK: - @Published

/// Transforms a @Published property into a Subject
internal extension AnySubject {

    convenience init<T: AnyObject>(publishedBy object: T, get getPublisher: KeyPath<T, some Publisher<Output, Never>>, set setKeyPath: ReferenceWritableKeyPath<T, Output>) where Failure == Never {
        let publisher = object[keyPath: getPublisher]
        self.init(
            receiveHandler: { publisher.receive(subscriber: $0) },
            sendValueHandler: { [weak object] in object?[keyPath: setKeyPath] = $0 },
            sendCompletionHandler: { _ in /* Published can't complete */ },
            sendSubscriptionHandler: { _ in /* ??? */ }
        )
    }
}


// MARK: - Public Initializers

internal extension AnySubject {

    convenience init(
        get publisher: some Publisher<Output, Failure>,
        set setHandler: @escaping (Output) -> Void
    ) {
        self.init(
            receiveHandler: { publisher.receive(subscriber: $0) },
            sendValueHandler: setHandler,
            sendCompletionHandler: { _ in /* Published can't complete */ },
            sendSubscriptionHandler: { _ in /* ??? */ }
        )
    }

    convenience init(_ wrapped: some Subject<Output, Failure>) {
        self.init(
            receiveHandler: { wrapped.receive(subscriber: $0) },
            sendValueHandler: { wrapped.send($0) },
            sendCompletionHandler: { wrapped.send(completion: $0) },
            sendSubscriptionHandler: { wrapped.send(subscription: $0) }
        )
    }
}


// MARK: - Type erasure

internal extension Subject {

    func eraseToAnySubject() -> AnySubject<Output, Failure> {
        if let existing = self as? AnySubject<Output, Failure> {
            return existing
        }
        return AnySubject(self)
    }
}
