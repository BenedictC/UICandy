import UIKit


public class SafeAreaAdjustmentContainer<Content: UIView>: Container<Content>, EdgesIgnoringSafeAreaSupporting {

    // MARK: Properties

    public let safeAreaIgnoringRegions: SafeAreaRegions
    let optionalEdgesIgnoringSafeArea: UIRectEdge?
    public var edgesIgnoringSafeArea: UIRectEdge {
        optionalEdgesIgnoringSafeArea ?? UIView.edgesIgnoringSafeArea(for: content)
    }

    var keyboardNotificationObservations: [Any]?
    var latestKeyboardFrame: CGRect?
    var additionalSafeAreaInsets = UIEdgeInsets.zero

    override public var safeAreaInsets: UIEdgeInsets {
        var result = super.safeAreaInsets
        result.top = max(result.top, additionalSafeAreaInsets.top)
        result.left = max(result.left, additionalSafeAreaInsets.left)
        result.bottom = max(result.bottom, additionalSafeAreaInsets.bottom)
        result.right = max(result.right, additionalSafeAreaInsets.right)
        return result
    }

    var isOuterMostKeyboardContainer: Bool {
        var ancestor = superview
        while let possibleContainer = ancestor {
            let containerAvoidsKeyboard = (possibleContainer as? EdgesIgnoringSafeAreaSupporting)
                .flatMap({ $0.safeAreaIgnoringRegions.contains(.keyboard) }) ?? false
            if containerAvoidsKeyboard {
                return false
            }
            ancestor = possibleContainer.superview
        }
        return true
    }


    // MARK: Instance life cycle

    init(content: Content, safeAreaIgnoringRegions regions: SafeAreaRegions, edgesIgnoringSafeArea: UIRectEdge?) {
        self.safeAreaIgnoringRegions = regions
        self.optionalEdgesIgnoringSafeArea = edgesIgnoringSafeArea
        super.init(content: content)

        let edgesIgnoringSafeArea = regions.contains(.container)
         ? edgesIgnoringSafeArea ?? UIView.edgesIgnoringSafeArea(for: content) // only respect safe edges for containers
        : .all // if it's not a .container then ignore all safe areas
        addAndFill(subview: content, overrideEdgesIgnoringSafeArea: edgesIgnoringSafeArea)

        if regions.contains(.keyboard) {
            initializeKeyboardAvoidance()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initializeKeyboardAvoidance() {
        let notificationCenter = NotificationCenter.default
        self.keyboardNotificationObservations = [
            notificationCenter.addObserver(forName: UIApplication.keyboardWillChangeFrameNotification, object: nil, queue: nil, using: { [weak self] notification in
                self?.updateSafeAreaInsets(notification: notification)
            }),
            notificationCenter.addObserver(forName: UIApplication.keyboardDidChangeFrameNotification, object: nil, queue: nil, using: { [weak self] notification in
                self?.updateSafeAreaInsets(notification: notification)
            }),
        ]
    }


    // MARK: Safe area insets

    func updateSafeAreaInsets(notification: Notification) {
        let keyboardFrameValue = notification.userInfo?[UIApplication.keyboardFrameEndUserInfoKey] as? NSValue
        let keyboardFrame = keyboardFrameValue?.cgRectValue ?? .zero
        latestKeyboardFrame = keyboardFrame

        let animationCurveValue = notification.userInfo?[UIApplication.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurve = animationCurveValue.flatMap { UIView.AnimationCurve(rawValue: $0.intValue) } ?? .linear

        let animationDurationValue = notification.userInfo?[UIApplication.keyboardAnimationDurationUserInfoKey] as? NSNumber
        let animationDuration = animationDurationValue?.doubleValue ?? 0.35
        updateSafeAreaInsets(animationCurve: animationCurve, animationDuration: animationDuration)
    }

    func updateSafeAreaInsets(animationCurve: UIView.AnimationCurve, animationDuration: TimeInterval) {
        guard let keyboardFrame = latestKeyboardFrame else {
            return
        }
        guard isOuterMostKeyboardContainer else {
            return
        }
        let contentFrame = content.convert(content.bounds, to: nil)
        let intersection = keyboardFrame.intersection(contentFrame)
        let keyboardEncroachment = intersection.height

        // Prevent a weird animation
        let oldValue = self.additionalSafeAreaInsets
        var newValue = oldValue
        newValue.bottom = keyboardEncroachment
        let noChange = newValue == oldValue
        if noChange {
            return
        }
        self.additionalSafeAreaInsets = newValue
        super.safeAreaInsetsDidChange()
        self.setNeedsLayout()
        if animationDuration > 0 {
            UIViewPropertyAnimator(duration: animationDuration, curve: animationCurve) {
                self.layoutIfNeeded()
            }.startAnimation()
        }
    }
}


// MARK: - Modifiers

public extension SomeView {

    func ignoresSafeArea(_ regions: SafeAreaRegions = .container, edges: UIRectEdge) -> SafeAreaAdjustmentContainer<Self> {
        return SafeAreaAdjustmentContainer(content: self, safeAreaIgnoringRegions: regions, edgesIgnoringSafeArea: edges)
    }
}


public extension SomeView {

    func avoidKeyboard() -> SafeAreaAdjustmentContainer<Self> {
        return SafeAreaAdjustmentContainer(content: self, safeAreaIgnoringRegions: .keyboard, edgesIgnoringSafeArea: nil)
    }
}
