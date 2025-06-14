import Combine
import UIKit


// MARK: - AlertController

open class AlertController<T>: UIAlertController, Presentable {

    // MARK: Types

    public typealias Success = T

    public enum Component {
        case text(AlertTextSubject<String?, Never>, configuration: (UITextField) -> Void = { _ in })
        case attributedText(AlertTextSubject<NSAttributedString?, Never>, configuration: (UITextField) -> Void = { _ in })
        case action(title: String, style: UIAlertAction.Style, result: Result<T, Error>, isPreferred: Bool, isEnabled: AnyPublisher<Bool, Never>)

        public static func cancelAction(_ title: String, error: Error = PresentableError.cancelled, isEnabled: some Publisher<Bool, Never> = Just(true)) -> Self {
            .action(title: title, style: .cancel, result: .failure(error), isPreferred: false, isEnabled: isEnabled.eraseToAnyPublisher())
        }

        public static func cancelAction(_ title: String, value: T, isEnabled: some Publisher<Bool, Never> = Just(true)) -> Self {
            .action(title: title, style: .cancel, result: .success(value), isPreferred: false, isEnabled: isEnabled.eraseToAnyPublisher())
        }

        public static func destructiveAction(_ title: String, value: T, isEnabled: some Publisher<Bool, Never> = Just(true)) -> Self {
            .action(title: title, style: .destructive, result: .success(value), isPreferred: false, isEnabled: isEnabled.eraseToAnyPublisher())
        }

        public static func standardAction(_ title: String, value: T, isEnabled: some Publisher<Bool, Never> = Just(true)) -> Self {
            .action(title: title, style: .default, result: .success(value), isPreferred: false, isEnabled: isEnabled.eraseToAnyPublisher())
        }

        public static func preferred(_ action: Self) -> Self {
            switch action {
            case .text, .attributedText:
                log.fault("Attempted to erroneously set a textField as a preferred action.")
                return action
                
            case .action(let title, let style, let result, _, let isEnabledPublisher):
                return .action(title: title, style: style, result: result, isPreferred: true, isEnabled: isEnabledPublisher)
            }
        }
    }


    // MARK: Properties

    private var continuation: CheckedContinuation<Success, Error>?
    private var cancellables = Set<AnyCancellable>()


    // MARK: Instance life cycle

    public convenience init(title: String?, message: String? = nil, preferredStyle: UIAlertController.Style = .alert, components: [Component]) {
        self.init(title: title, message: message, preferredStyle: preferredStyle)

        var preferredAction: UIAlertAction?
        for component in components {
            switch component {
            case .action(let title, let style, let result, let isPreferred, let isEnabledPublisher):
                let action = UIAlertAction(title: title, style: style) { [weak self] _ in
                    self?.continuation?.resume(with: result)
                }
                isEnabledPublisher
                    .sink { action.isEnabled = $0 }
                    .store(in: &cancellables)
                addAction(action)
                if isPreferred {
                    preferredAction = action
                }

            case .attributedText(let subject, let configuration):
                addTextField { textField in
                    textField.placeholder = subject.placeholder
                    configuration(textField)
                    _ = textField.attributedText(bindsTo: subject)
                }

            case .text(let subject, let configuration):
                addTextField { textField in
                    textField.placeholder = subject.placeholder
                    configuration(textField)
                    _ = textField.text(bindsTo: subject)
                }
            }
        }
        self.preferredAction = preferredAction
    }


    // MARK: View life cycle

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Fix for incorrect tint color
        if let tintColor = view.tintColor {
            view.tintColor = tintColor.withAlphaComponent(0.9)
            view.tintColor = tintColor
        }
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        didDisappear()
    }


    // MARK: Presentable

    public func fulfilContinuationForCancelledPresentation(_ continuation: CheckedContinuation<Success, Error>) {
        self.continuation = continuation
    }
}


// MARK: - Supporting types

@propertyWrapper
public struct AlertText {

    public var wrappedValue: String? {
        get { projectedValue.value }
        // nonmutating is to avoid crashes due to re-entrant when the get is called by a subscriber of the underlying subject
        nonmutating
        set { projectedValue.send(newValue) }
    }
    public let projectedValue: AlertTextSubject<String?, Never>

    public init(wrappedValue: String?, placeholder: String? = nil) {
        self.projectedValue = AlertTextSubject(placeholder: placeholder, initialValue: wrappedValue)
    }
}


@propertyWrapper
public struct AlertAttributedText {

    public var wrappedValue: NSAttributedString? {
        get { projectedValue.value }
        // nonmutating is to avoid crashes due to re-entrant when the get is called by a subscriber of the underlying subject
        nonmutating
        set { projectedValue.send(newValue) }
    }

    public let projectedValue: AlertTextSubject<NSAttributedString?, Never>

    public init(wrappedValue: NSAttributedString?, placeholder: String? = nil) {
        self.projectedValue = AlertTextSubject(placeholder: placeholder, initialValue: wrappedValue)
    }
}


public final class AlertTextSubject<Output, Failure: Error>: Subject {

    let placeholder: String?
    private let subject: CurrentValueSubject<Output, Failure>

    var value: Output { subject.value }

    init(placeholder: String?, initialValue: Output) {
        self.placeholder = placeholder
        self.subject = CurrentValueSubject(initialValue)
    }

    public func send(_ value: Output) {
        subject.send(value)
    }

    public func send(completion: Subscribers.Completion<Failure>) {
        subject.send(completion: completion)
    }

    public func send(subscription: Subscription) {
        subject.send(subscription: subscription)
    }

    public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        subject.receive(subscriber: subscriber)
    }
}
