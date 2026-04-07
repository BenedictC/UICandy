import UIKit


public extension UIContextualAction {

    convenience init(
        style: UIContextualAction.Style,
        title: String?,
        image: UIImage? = nil,
        backgroundColor: UIColor? = nil,
        handler asyncHandler: @escaping (UIContextualAction, UIView) async -> Bool
    ) {
        let handler: UIContextualAction.Handler = { action, view, completion in
            Task { @MainActor in
                let result = await asyncHandler(action, view)
                completion(result)
            }
        }
        self.init(style: style, title: title, handler: handler)
        if let image { self.image = image }
        if let backgroundColor { self.backgroundColor = backgroundColor }
    }
}
