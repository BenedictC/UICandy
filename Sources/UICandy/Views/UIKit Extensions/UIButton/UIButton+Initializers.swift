import UIKit


// MARK: - Convenience inits

@available(iOS 15.0, *)
public extension UIButton {

    enum Style {
        case plain, gray, tinted, filled

        public static let borderless = Self.plain
        public static let bordered = Self.gray
        public static let borderedTinted = Self.tinted
        public static let borderedProminent = Self.filled

        func makeConfiguration() -> UIButton.Configuration {
            switch self {
            case .plain: return UIButton.Configuration.plain()
            case .gray: return UIButton.Configuration.gray()
            case .tinted: return UIButton.Configuration.tinted()
            case .filled: return UIButton.Configuration.filled()
            }
        }
    }


    convenience init(
        title: String? = nil,
        image: UIImage? = nil, // | imageName: String | systemImageName: String
        role: UIButton.Role = .normal,
        style: Style = .borderless, // used to determine which factory to call on UIButton.Configuration
        configuration configurator: (inout UIButton.Configuration) -> Void = { _ in },
        action: @escaping () -> Void
    ) {
        let configuration = style.makeConfiguration().configure { configuration in
            configuration.title = title
            configuration.image = image
            configurator(&configuration)
        }
        let primaryAction = UIAction { _ in action() }
        self.init(configuration: configuration, primaryAction: primaryAction)
        self.role = role
    }

    convenience init(
        title: String? = nil,
        imageName: String?,
        role: UIButton.Role = .normal,
        style: Style = .borderless, // used to determine which factory to call on UIButton.Configuration
        configuration configurator: (inout UIButton.Configuration) -> Void = { _ in },
        action: @escaping () -> Void
    ) {
        let image = imageName.flatMap { UIImage(named: $0) }
        self.init(title: title, image: image, role: role, style: style, configuration: configurator, action: action)
    }

    convenience init(
        title: String? = nil,
        systemImageName: String?,
        role: UIButton.Role = .normal,
        style: Style = .borderless, // used to determine which factory to call on UIButton.Configuration
        configuration configurator: (inout UIButton.Configuration) -> Void = { _ in },
        action: @escaping () -> Void
    ) {
        let image = systemImageName.flatMap { UIImage(systemName: $0) }
        self.init(title: title, image: image, role: role, style: style, configuration: configurator, action: action)
    }

    
    // MARK: Without action

    convenience init(
        title: String? = nil,
        image: UIImage? = nil, // | imageName: String | systemImageName: String
        role: UIButton.Role = .normal,
        style: Style = .borderless, // used to determine which factory to call on UIButton.Configuration
        configuration configurator: (inout UIButton.Configuration) -> Void = { _ in }
    ) {
        let configuration = style.makeConfiguration().configure { configuration in
            configuration.title = title
            configuration.image = image
            configurator(&configuration)
        }
        self.init(configuration: configuration, primaryAction: nil)
        self.role = role
    }

    convenience init(
        title: String? = nil,
        imageName: String?,
        role: UIButton.Role = .normal,
        style: Style = .borderless, // used to determine which factory to call on UIButton.Configuration
        configuration configurator: (inout UIButton.Configuration) -> Void = { _ in }
    ) {
        let image = imageName.flatMap { UIImage(named: $0) }
        self.init(title: title, image: image, role: role, style: style, configuration: configurator)
    }

    convenience init(
        title: String? = nil,
        systemImageName: String?,
        role: UIButton.Role = .normal,
        style: Style = .borderless, // used to determine which factory to call on UIButton.Configuration
        configuration configurator: (inout UIButton.Configuration) -> Void = { _ in }
    ) {
        let image = systemImageName.flatMap { UIImage(systemName: $0) }
        self.init(title: title, image: image, role: role, style: style, configuration: configurator)
    }
}

@available(iOS 14.0, *)
public extension UIButton {

    convenience init(type: UIButton.ButtonType, action: (() -> Void)? = nil) {
        let primaryAction = action.flatMap { action in UIAction(handler: { _ in action() }) }
        self.init(type: type, primaryAction: primaryAction)
    }
}


// MARK: - UIButton.Configuration

@available(iOS 15.0, *)
public extension UIButton.Configuration {

    func configure(using block: (inout Self) -> Void) -> Self {
        var config = self
        block(&config)
        return config
    }
}
