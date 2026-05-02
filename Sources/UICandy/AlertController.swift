import UIKit


// MARK: - AlertController

public class AlertController: UIAlertController {

    // MARK: Properties

    var inputs = [AlertInput]()


    // MARK: Instance life cycle

    public convenience init(
        title: String?,
        message: String? = nil,
        preferredStyle: UIAlertController.Style = .alert,
        inputs: [AlertInput] = [],
        actions: [AlertAction],
    ) {
        self.init(title: title, message: message, preferredStyle: preferredStyle)
        self.inputs = inputs

        for input in inputs {
            addTextField(configurationHandler: { input.configure(textField: $0) })
        }
        var preferredAlertAction: UIAlertAction?
        for action in actions {
            addAction(action)
            if action.isPreferred {
                preferredAlertAction = action
            }
        }
        self.preferredAction = preferredAlertAction
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
        textField.addTarget(self, action: #selector(handleValueChanged(of: )), for: .editingChanged)
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

public final class AlertAction: UIAlertAction {

    public internal(set) var isPreferred = false

    convenience init(
        title: String,
        style: UIAlertAction.Style,
        isPreferred: Bool,
        isEnabled: Bool,
        handler: @escaping (UIAlertAction) -> Void
    ) {
        self.init(title: title, style: style, handler: handler)
        self.isPreferred = isPreferred
        self.isEnabled = isEnabled
    }
}


public extension AlertAction {

    static func cancel(
        title: String,
        isPreferred: Bool = false,
        isEnabled: Bool = true,
        handler: @escaping (UIAlertAction) -> Void = { _ in }
    ) -> Self {
        Self(title: title, style: .cancel, isPreferred: isPreferred, isEnabled: isEnabled, handler: handler)
    }

    static func destructive(
        title: String,
        isPreferred: Bool = false,
        isEnabled: Bool = true,
        handler: @escaping (UIAlertAction) -> Void = { _ in }
    ) -> Self {
        Self(title: title, style: .destructive, isPreferred: isPreferred, isEnabled: isEnabled, handler: handler)
    }

    static func `default`(
        title: String,
        isPreferred: Bool = false,
        isEnabled: Bool = true,
        handler: @escaping (UIAlertAction) -> Void = { _ in }
    ) -> Self {
        Self(title: title, style: .default, isPreferred: isPreferred, isEnabled: isEnabled, handler: handler)
    }
}


public extension AlertAction {

    var isCancel: Bool { style == .cancel }

    var isDestructive: Bool { style == .destructive }

    var isDefault: Bool { style == .default }
}
