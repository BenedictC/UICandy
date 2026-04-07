import UIKit


// MARK: - AlertController

public class AlertController: UIAlertController {

    // MARK: Properties

    public var completion: ((AlertAction?) -> Void)?
    public private(set) var selectedAction: AlertAction?


    // MARK: Instance life cycle

    public convenience init(
        title: String?,
        message: String? = nil,
        preferredStyle: UIAlertController.Style = .alert,
        inputs: [AlertInput] = [],
        actions: [AlertAction],
        completion: ((AlertAction?) -> Void)? = nil
    ) {
        self.init(title: title, message: message, preferredStyle: preferredStyle)

        for input in inputs {
            addTextField(configurationHandler: { input.configure(textField: $0) })
        }
        var preferredAlertAction: UIAlertAction?
        for action in actions {
            let uiAlertAction = action.initializeUIAlertAction(handler: { [weak self] _ in
                self?.selectedAction = action
            })
            addAction(uiAlertAction)
            if action.isPreferred {
                preferredAlertAction = uiAlertAction
            }
        }
        self.preferredAction = preferredAlertAction

        self.completion = completion
    }


    // MARK: View life cycle

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Fix for incorrect tint color
        if let tintColor = view.tintColor {
            view.tintColor = tintColor.withAlphaComponent(0.9)
            view.tintColor = tintColor
        }
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        completion?(selectedAction)
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

public final class AlertAction {

    public let title: String
    public let style: UIAlertAction.Style
    public let isPreferred: Bool

    public var isEnabled: Bool {
        didSet { uiAlertAction?.isEnabled = isEnabled }
    }

    internal var uiAlertAction: UIAlertAction?


    init(
        title: String,
        style: UIAlertAction.Style,
        isPreferred: Bool,
        isEnabled: Bool
    ) {
        self.title = title
        self.style = style
        self.isPreferred = isPreferred
        self.isEnabled = isEnabled
    }

    func initializeUIAlertAction(handler: @escaping (UIAlertAction) -> Void) -> UIAlertAction {
        guard uiAlertAction == nil else {
            fatalError("Attempted to re-use AlertAction")
        }
        let action = UIAlertAction(title: title, style: style, handler: handler)
        action.isEnabled = isEnabled
        self.uiAlertAction = action
        return action
    }
}


public extension AlertAction {

    static func cancel(
        title: String,
        isPreferred: Bool = false,
        isEnabled: Bool = true
    ) -> Self {
        Self(title: title, style: .cancel, isPreferred: isPreferred, isEnabled: isEnabled)
    }

    static func destructive(
        title: String,
        isPreferred: Bool = false,
        isEnabled: Bool = true
    ) -> Self {
        Self(title: title, style: .destructive, isPreferred: isPreferred, isEnabled: isEnabled)
    }

    static func `default`(
        title: String,
        isPreferred: Bool = false,
        isEnabled: Bool = true
    ) -> Self {
        Self(title: title, style: .default, isPreferred: isPreferred, isEnabled: isEnabled)
    }
}


public extension AlertAction {

    var isCancel: Bool { style == .cancel }

    var isDestructive: Bool { style == .destructive }

    var isDefault: Bool { style == .default }
}
