import UIKit
import UICandy
import Combine


class FormViewController: ViewController {

    
    // MARK: Types
    
    enum Status {
        case invalid, ready, waiting
    }
    
    typealias ValidationKeyPath = KeyPath<RegistrationForm, AnyPublisher<Bool, Never>>
    
    
    // MARK: Properties
    
    private let form = RegistrationForm()
    
    @Binding private var isSubmitInProgress = false
    @Binding private var validationKeyPaths = Set<ValidationKeyPath>()
    private lazy var status = Publishers
        .CombineLatest($isSubmitInProgress, form.isValid)
        .map { pair -> Status in
            let (isSubmitInProgress, isValid) = pair
            if isSubmitInProgress { return .waiting }
            return isValid ? .ready : .invalid
        }
    private lazy var nameValidationErrorLabelAlpha = makeValidationPublisher(for: \.isNameValid)
    private lazy var emailValidationErrorLabelAlpha = makeValidationPublisher(for: \.isEmailValid)
    private lazy var passwordValidationErrorLabelAlpha = makeValidationPublisher(for: \.isPasswordValid)
    
    
    // Content views
    
    private lazy var nameTextField = makeTextField(placeholder: "Name")
        .text(bindsTo: Binding(forPropertyOf: form, at: \.$name, \.name))
        .delegateWithReturnAction(next: emailTextField)
        .onEvent(.editingDidEnd) { [weak self] _ in self?.didEndEditing(for: \.isNameValid) }
    
    private lazy var nameValidationErrorLabel = makeValidationErrorLabel(text: "Name must be at least 1 character long")
        .alpha(nameValidationErrorLabelAlpha)
    
    private lazy var emailTextField = makeTextField(placeholder: "Email")
        .keyboardType(.emailAddress)
        .autocapitalizationType(.none)
        .text(bindsTo: Binding(forPropertyOf: form, at: \.$email, \.email))
        .delegateWithReturnAction(next: passwordTextField)
        .onEvent(.editingDidEnd) { [weak self] _ in self?.didEndEditing(for: \.isEmailValid) }
    
    private lazy var emailValidationErrorLabel = makeValidationErrorLabel(text: "Email must be a valid email address")
        .alpha(emailValidationErrorLabelAlpha)
    
    private lazy var passwordTextField = makeTextField(placeholder: "Password")
        .isSecureTextEntry(true)
        .text(bindsTo: Binding(forPropertyOf: form, at: \.$password, \.password))
        .delegateWithReturnAction { [weak self] in self?.submit() }
        .onEvent(.editingDidEnd) { [weak self] _ in self?.didEndEditing(for: \.isPasswordValid) }
    
    private lazy var passwordValidationErrorLabel = makeValidationErrorLabel(text: "Password must be at least 8 characters long and contain a letter and a number")
        .alpha(passwordValidationErrorLabelAlpha)
    
    private lazy var submitButton = UIButton(title: "Submit", action: { [weak self] in self?.submit() })
        .enabled(status.isEqualTo(.ready))
    
    private lazy var activityIndicator = UIActivityIndicatorView(style: .large, isActive: status.isEqualTo(.waiting))
        .backgroundColor(.secondarySystemFill.withAlphaComponent(0.5))
    
    
    // Layout views
    
    lazy var rootView = ScrollingContentLayout(configuration: .init(paddingColor: .blue)) {
        ZStack(alignment: .fill) {
            VStack(spacing: 10) {
                VStack {
                    nameTextField
                        .frame(height: 44)
                    nameValidationErrorLabel
                }
                VStack {
                    emailTextField
                        .frame(height: 44)
                    emailValidationErrorLabel
                }
                VStack {
                    passwordTextField
                        .frame(height: 44)
                    passwordValidationErrorLabel
                }
                submitButton
            }
            .contentHugs(in: .vertical, at: .defaultLow)
            activityIndicator
                .contentHugs(in: .vertical, at: .defaultLow)
        }
    }
    
    
    // MARK: - Instance life cycle
    
    func awake() {
        assign(to: \.navigationItem.title, from: form.$name)
    }
}


// MARK: - View life cycle

extension FormViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        nameTextField.becomeFirstResponder()
    }
}


// MARK: - Actions

private extension FormViewController {
    
    func didEndEditing(for validationKeyPath: ValidationKeyPath) {
        validationKeyPaths.insert(validationKeyPath)
    }
    
    func resetState() {
        form.reset()
        nameTextField.becomeFirstResponder()
        // Clearing validationKeyPaths has to be done after setting first responder because when the
        // resigning textField loses focus it is added to validationKeyPaths which would be incorrect
        validationKeyPaths.removeAll()
    }
    
    func submit() {
        guard RegistrationForm.isValid(form) else {
            return
        }
        rootView.resignFirstResponder()
        isSubmitInProgress = true
        let alertVC = AlertController<Void>(title: "Success!", message: "Form submitted", preferredStyle: .alert,components: [
            .standardAction("OK", value: ())
        ])
        Task {
            try? await Task.sleep(for: .seconds(1))
            self.isSubmitInProgress = false
            try? await self.presentModal(alertVC, animated: true)
            resetState()
        }
    }
}


// MARK: - Factories

private extension FormViewController {
    
    func makeValidationPublisher(for validationKeyPath: ValidationKeyPath) -> some Publisher<CGFloat, Never> {
        let validationPublisher = form[keyPath: validationKeyPath]
        return Publishers.CombineLatest(validationPublisher, $validationKeyPaths)
            .map { pair in
                let (isValid, validationKeyPaths) = pair
                let shouldShowValidation = validationKeyPaths.contains(validationKeyPath)
                return shouldShowValidation && !isValid ? CGFloat(1) : CGFloat(0)
            }
    }
    
    func makeTextField(placeholder: String) -> UITextField {
        UITextField()
            .borderStyle(.roundedRect)
            .placeholder(placeholder)
    }
    
    private func makeValidationErrorLabel(text: String) -> UILabel {
        UILabel()
            .text(text)
            .font(.preferredFont(forTextStyle: .caption1))
            .numberOfLines(0)
            .textColor(.systemRed)
    }
}
