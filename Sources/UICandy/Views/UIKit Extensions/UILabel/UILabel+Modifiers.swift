import UIKit


public extension UILabel {

    func text(_ value: String?) -> Self {
        self.text = value
        return self
    }

    func font(_ value: UIFont) -> Self {
        self.font = value
        return self
    }

    func textColor(_ value: UIColor!) -> Self {
        self.textColor = value
        return self
    }

    func shadowColor(_ value: UIColor?) -> Self {
        self.shadowColor = value
        return self
    }

    func shadowOffset(_ value: CGSize) -> Self {
        self.shadowOffset = value
        return self
    }

    func textAlignment(_ value: NSTextAlignment) -> Self {
        self.textAlignment = value
        return self
    }

    func lineBreakMode(_ value: NSLineBreakMode) -> Self {
        self.lineBreakMode = value
        return self
    }

    func attributedText(_ value: NSAttributedString?) -> Self {
        self.attributedText = value
        return self
    }

    func highlightedTextColor(_ value: UIColor?) -> Self {
        self.highlightedTextColor = value
        return self
    }

    func isHighlighted(_ value: Bool) -> Self {
        self.isHighlighted = value
        return self
    }

    func isUserInteractionEnabled(_ value: Bool) -> Self {
        self.isUserInteractionEnabled = value
        return self
    }

    func isEnabled(_ value: Bool) -> Self {
        self.isEnabled = value
        return self
    }

    func numberOfLines(_ value: Int) -> Self {
        self.numberOfLines = value
        return self
    }

    func adjustsFontSizeToFitWidth(_ value: Bool) -> Self {
        self.adjustsFontSizeToFitWidth = value
        return self
    }

    func baselineAdjustment(_ value: UIBaselineAdjustment) -> Self {
        self.baselineAdjustment = value
        return self
    }

    func minimumScaleFactor(_ value: CGFloat) -> Self {
        adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = value
        return self
    }

    func allowsDefaultTighteningForTruncation(_ value: Bool) -> Self {
        self.allowsDefaultTighteningForTruncation = value
        return self
    }

    func preferredMaxLayoutWidth(_ value: CGFloat) -> Self {
        self.preferredMaxLayoutWidth = value
        return self
    }

    func showsExpansionTextWhenTruncated(_ value: Bool) -> Self {
        self.showsExpansionTextWhenTruncated = value
        return self
    }
}


@available(iOS 14.0, *)
public extension UILabel {

    func lineBreakStrategy(_ value: NSParagraphStyle.LineBreakStrategy) -> Self {
        self.lineBreakStrategy = value
        return self
    }
}
