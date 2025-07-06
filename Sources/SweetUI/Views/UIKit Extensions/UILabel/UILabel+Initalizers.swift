import UIKit


// MARK: - Initializers

public extension UILabel {

    convenience init(text: String?) {
        self.init()
        self.text = text
    }

    convenience init(attributedText: NSAttributedString) {
        self.init()
        self.attributedText = attributedText
    }

    convenience init(_ key: StaticString, tableName: StaticString? = nil, bundle: Bundle = .main, comment: StaticString) {
        self.init()
        let text = NSLocalizedString(
            String(describing: key),
            tableName: tableName.flatMap { String(describing: $0) },
            bundle: bundle,
            comment: String(describing: comment)
        )
        self.text = text
    }
}
