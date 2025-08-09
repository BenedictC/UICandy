import UIKit


// MARK: - AlertController

open class AlertController<T>: UIAlertController, Presentable {

    // MARK: Types

    public typealias Success = T


    // MARK: Properties

    private var continuation: CheckedContinuation<Success, Error>?


    // MARK: Instance life cycle

    public convenience init(
        title: String?,
        message: String? = nil,
        preferredStyle: UIAlertController.Style = .alert,
        inputs: [AlertInput] = [],
        actions: [AlertAction<T>]
    ) {
        self.init(title: title, message: message, preferredStyle: preferredStyle)

        for input in inputs {
            addTextField(configurationHandler: { input.configure(textField: $0) })
            "TODO: Handle text changes"
        }

        var preferredAlertAction: UIAlertAction?
        for action in actions {
            let uiAlertAction = UIAlertAction(title: action.title, style: action.style) { [weak self] uiAction in
                self?.continuation?.resume(with: .success(action.response))
            }
            action.uiAlertAction = uiAlertAction
            addAction(uiAlertAction)
            if action.isPreferred {
                preferredAlertAction = uiAlertAction
            }
        }
        self.preferredAction = preferredAlertAction
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


// MARK: - AlertInput

public final class AlertInput: NSObject {


    private let configuration: (UITextField) -> Void
    private let valueChangedHandler: (UITextField) -> Void
    public private(set) var text: String?
    public private(set) var attributedText: NSAttributedString?

    public init(
        configuration: @escaping (UITextField) -> Void,
        valueChangedHandler: @escaping (UITextField) -> Void = { _ in }
    ) {
        self.configuration = configuration
        self.valueChangedHandler = valueChangedHandler
    }

    func configure(textField: UITextField) {
        configuration(textField)
        textField.addTarget(self, action: #selector(handleValueChanged(of: )), for: .valueChanged)
        handleValueChanged(of: textField) // initialize text & attributedText
    }

    @objc
    private func handleValueChanged(of sender: AnyObject?) {
        guard let textField = sender as? UITextField else { return }
        self.text = textField.text
        self.attributedText = textField.attributedText
        valueChangedHandler(textField)
    }
}


// MARK: - AlertAction

public final class AlertAction<T> {

    public let title: String
    public let style: UIAlertAction.Style
    public let response: T
    public let isPreferred: Bool

    public var isEnabled: Bool {
        didSet { uiAlertAction?.isEnabled = isEnabled }
    }

    internal var uiAlertAction: UIAlertAction? {
        didSet { uiAlertAction?.isEnabled = isEnabled }
    }


    init(
        title: String,
        style: UIAlertAction.Style = .default,
        response: T,
        isPreferred: Bool = false,
        isEnabled: Bool = true
    ) {
        self.title = title
        self.style = style
        self.response = response
        self.isPreferred = isPreferred
        self.isEnabled = isEnabled
    }
}



public extension AlertAction {

    static func cancel(
        title: String,
        response: T,
        isPreferred: Bool = false,
        isEnabled: Bool = true
    ) -> Self {
        Self(title: title, style: .cancel, response: response, isPreferred: isPreferred, isEnabled: isEnabled)
    }

    static func destructive(
        title: String,
        response: T,
        isPreferred: Bool = false,
        isEnabled: Bool = true
    ) -> Self {
        Self(title: title, style: .destructive, response: response, isPreferred: isPreferred, isEnabled: isEnabled)
    }

    static func `default`(
        title: String,
        response: T,
        isPreferred: Bool = false,
        isEnabled: Bool = true
    ) -> Self {
        Self(title: title, style: .default, response: response, isPreferred: isPreferred, isEnabled: isEnabled)
    }
}


// MARK: - WIP

func todo() {
    let confirmAction = AlertAction(title: "Confirm", response: true)
    let alertInput = AlertInput { textField in
        let isEmpty = (textField.text ?? "").trimmingCharacters(in: .whitespaces).isEmpty
        let isValid = !isEmpty
        confirmAction.isEnabled = isValid
    }

    let alertController = AlertController(
        title: "Hiya!",
        inputs: [
            alertInput
        ],
        actions: [
            confirmAction,
            .cancel(title: "Cancel", response: false)
        ])
}
