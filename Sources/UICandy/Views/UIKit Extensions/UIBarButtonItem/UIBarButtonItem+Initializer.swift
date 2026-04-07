import UIKit


// MARK: - systemItem based init

@available(iOS 14, *)
public extension UIBarButtonItem {
    
    convenience init(systemItem: UIBarButtonItem.SystemItem, style: UIBarButtonItem.Style = .plain, action handler: @MainActor @escaping (Self) -> Void) {
        let action = UIAction { handler(($0.sender as? Self)!) }
        self.init(systemItem: systemItem, primaryAction: action, menu: nil)
        self.style = style
    }
    
    convenience init(systemItem: UIBarButtonItem.SystemItem, style: UIBarButtonItem.Style = .plain, action handler: @MainActor @escaping () -> Void) {
        let action = UIAction { _ in handler() }
        self.init(systemItem: systemItem, primaryAction: action, menu: nil)
        self.style = style
    }
    
    convenience init(systemItem: UIBarButtonItem.SystemItem, style: UIBarButtonItem.Style = .plain, menu: UIMenu) {
        self.init(systemItem: systemItem, primaryAction: nil, menu: menu)
        self.style = style
    }
    
    convenience init(systemItem: UIBarButtonItem.SystemItem, style: UIBarButtonItem.Style = .plain) {
        self.init(systemItem: systemItem, primaryAction: nil, menu: nil)
        self.style = style
    }
}


// MARK: - Title + image based init

@available(iOS 14, *)
public extension UIBarButtonItem {
    
    // # image:
    
    convenience init(title: String? = nil, image: UIImage? = nil, style: UIBarButtonItem.Style = .plain, action handler: @MainActor @escaping (Self) -> Void) {
        let action = UIAction { handler(($0.sender as? Self)!) }
        if let title { action.title = title }
        if let image { action.image = image }
        self.init(title: title, image: image, primaryAction: action)
        self.style = style
    }
    
    convenience init(title: String? = nil, image: UIImage? = nil, style: UIBarButtonItem.Style = .plain, action handler: @MainActor @escaping () -> Void) {
        let action = UIAction { _ in handler() }
        if let title { action.title = title }
        if let image { action.image = image }
        self.init(title: title, image: image, primaryAction: action)
        self.style = style
    }
    
    convenience init(title: String? = nil, image: UIImage? = nil, style: UIBarButtonItem.Style = .plain, menu: UIMenu) {
        self.init(title: title, image: image, primaryAction: nil, menu: menu)
        self.style = style
    }
    
    convenience init(title: String? = nil, image: UIImage? = nil, style: UIBarButtonItem.Style = .plain) {
        self.init(title: title, image: image, primaryAction: nil, menu: nil)
        self.style = style
    }
    
    
    // # imageName:
    
    convenience init(title: String? = nil, imageName: String, style: UIBarButtonItem.Style = .plain, action handler: @MainActor @escaping (Self) -> Void) {
        let image = UIImage(named: imageName)
        let action = UIAction { handler(($0.sender as? Self)!) }
        if let title { action.title = title }
        if let image { action.image = image }
        self.init(title: title, image: image, primaryAction: action)
        self.style = style
    }
    
    convenience init(title: String? = nil, imageName: String, style: UIBarButtonItem.Style = .plain, action handler: @MainActor @escaping () -> Void) {
        let image = UIImage(named: imageName)
        let action = UIAction { _ in handler() }
        if let title { action.title = title }
        if let image { action.image = image }
        self.init(title: title, image: image, primaryAction: action)
        self.style = style
    }
    
    convenience init(title: String? = nil, imageName: String, style: UIBarButtonItem.Style = .plain, menu: UIMenu) {
        let image = UIImage(named: imageName)
        self.init(title: title, image: image, primaryAction: nil, menu: menu)
        self.style = style
    }
    
    convenience init(title: String? = nil, imageName: String, style: UIBarButtonItem.Style = .plain) {
        let image = UIImage(named: imageName)
        self.init(title: title, image: image, primaryAction: nil, menu: nil)
        self.style = style
    }
    
    
    // # systemImageName:
    
    convenience init(title: String? = nil, systemImageName: String, style: UIBarButtonItem.Style = .plain, action handler: @MainActor @escaping (Self) -> Void) {
        let image = UIImage(systemName: systemImageName)
        let action = UIAction { handler(($0.sender as? Self)!) }
        if let title { action.title = title }
        if let image { action.image = image }
        self.init(title: title, image: image, primaryAction: action)
        self.style = style
    }
    
    convenience init(title: String? = nil, systemImageName: String, style: UIBarButtonItem.Style = .plain, action handler: @MainActor @escaping () -> Void) {
        let image = UIImage(systemName: systemImageName)
        let action = UIAction { _ in handler() }
        if let title { action.title = title }
        if let image { action.image = image }
        self.init(title: title, image: image, primaryAction: action)
        self.style = style
    }
    
    convenience init(title: String? = nil, systemImageName: String, style: UIBarButtonItem.Style = .plain, menu: UIMenu) {
        let image = UIImage(systemName: systemImageName)
        self.init(title: title, image: image, primaryAction: nil, menu: menu)
        self.style = style
    }
    
    convenience init(title: String? = nil, systemImageName: String, style: UIBarButtonItem.Style = .plain) {
        let image = UIImage(systemName: systemImageName)
        self.init(title: title, image: image, primaryAction: nil, menu: nil)
        self.style = style
    }
}


// MARK: - CustomView

public extension UIBarButtonItem {
    
    convenience init(customView builder: () -> UIView) {
        let customView = builder()
        self.init(customView: customView)
    }
}
