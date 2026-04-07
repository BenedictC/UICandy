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
    var contentEdgeInsets = UIEdgeInsets.zero {
        didSet {
            if let content = content as? UIScrollView {
                content.contentInset = contentEdgeInsets
                content.scrollIndicatorInsets = contentEdgeInsets
            } else {
                contentEdgeConstraints?.top.constant = contentEdgeInsets.top
                contentEdgeConstraints?.bottom.constant = -contentEdgeInsets.bottom
                contentEdgeConstraints?.left.constant = contentEdgeInsets.left
                contentEdgeConstraints?.right.constant = -contentEdgeInsets.right
                setNeedsLayout()
            }
        }
    }
    private var contentEdgeConstraints: EdgeConstraints?
    private var keyboardFrameChangeNotification: Notification?

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

    init(content: Content, safeAreaIgnoringRegions regions: SafeAreaRegions, edgesIgnoringSafeArea: UIRectEdge) {
        self.safeAreaIgnoringRegions = regions
        self.optionalEdgesIgnoringSafeArea = edgesIgnoringSafeArea
        super.init(content: content)
       
        self.contentEdgeConstraints = addAndFill(subview: content, edgesIgnoringSafeArea: edgesIgnoringSafeArea)

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
                self?.keyboardFrameChangeNotification = notification
                self?.setNeedsLayout()
            }),
            notificationCenter.addObserver(forName: UIApplication.keyboardDidChangeFrameNotification, object: nil, queue: nil, using: { [weak self] notification in
                self?.keyboardFrameChangeNotification = notification
                self?.setNeedsLayout()
            }),
        ]
    }


    // MARK: Safe area insets

    open override func layoutSubviews() {
        if let keyboardFrameChangeNotification {
            updateSafeAreaInsets(notification: keyboardFrameChangeNotification)
            self.keyboardFrameChangeNotification = nil
        }

        super.layoutSubviews()
    }

    func updateSafeAreaInsets(notification: Notification) {
        guard let targetScreen = self.window?.screen else {
            // view is not on screen
            return
        }
        // screen is only available from 16.1
        if let changedScreen = notification.object as? UIScreen {
            let isOnScreen = targetScreen == changedScreen
            guard isOnScreen else {
                return
            }
        }

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
        let contentFrame = self.convert(self.bounds, to: nil)
        let intersection = keyboardFrame.intersection(contentFrame)
        let keyboardEncroachment = intersection.height

        // Prevent a weird animation
        let oldValue = self.contentEdgeInsets
        var newValue = oldValue
        newValue.bottom = keyboardEncroachment
        let noChange = newValue == oldValue
        if noChange {
            return
        }

        self.contentEdgeInsets = newValue
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
        return SafeAreaAdjustmentContainer(content: self, safeAreaIgnoringRegions: .keyboard, edgesIgnoringSafeArea: .all)
    }
}
