import UIKit


public class ScrollView<T: UIView>: UIScrollView {

    // MARK: - Properties

    public let axes: Axis
    public let content: T


    // MARK: - Instance life cycle

    public init(axes: Axis = .vertical, keyboardDismissMode: UIScrollView.KeyboardDismissMode? = nil, delegate: UIScrollViewDelegate? = nil, content: T) {
        self.axes = axes
        self.content = content
        super.init(frame: .zero)
        if let keyboardDismissMode = keyboardDismissMode {
            self.keyboardDismissMode = keyboardDismissMode
        }
        self.delegate = delegate

        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            content.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor),
            content.leftAnchor.constraint(equalTo: contentLayoutGuide.leftAnchor),
            content.rightAnchor.constraint(equalTo: contentLayoutGuide.rightAnchor),
        ])

        var contentConstraints = [NSLayoutConstraint]()
        let shouldConstrainWidth = !axes.contains(.horizontal)
        if shouldConstrainWidth {
            contentConstraints.append(content.widthAnchor.constraint(equalTo: frameLayoutGuide.widthAnchor))
        }
        let shouldConstrainHeight = !axes.contains(.vertical)
        if shouldConstrainHeight {
            contentConstraints.append(content.heightAnchor.constraint(equalTo: frameLayoutGuide.heightAnchor))
        }
        NSLayoutConstraint.activate(contentConstraints)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


public extension ScrollView {

    convenience init(axes: Axis = .vertical, keyboardDismissMode: UIScrollView.KeyboardDismissMode? = nil, delegate: UIScrollViewDelegate? = nil, contentBuilder: () -> T) {
        let content = contentBuilder()
        self.init(axes: axes, keyboardDismissMode: keyboardDismissMode, delegate: delegate, content: content)
    }
}
