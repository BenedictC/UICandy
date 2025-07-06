import UIKit


// MARK: - Supporting Types

public enum MaskSizingView {
    case content, mask
}


// MARK: - Mask

public final class Mask<ContentView: UIView, MaskView: UIView>: UIView {

    // MARK: Properties

    public let sizingView: MaskSizingView
    public let alignment: ContentAlignment
    public let content: ContentView
    public let contentMask: MaskView

    private let mainView: UIView


    // MARK: Instance life cycle

    public init(sizingView: MaskSizingView = .content, alignment: ContentAlignment = .fill, content: ContentView, mask: MaskView) {
        self.sizingView = sizingView
        self.alignment = alignment
        self.content = content
        self.contentMask = mask

        self.mainView = switch sizingView {
        case .content:
            MaskSizedByContent(maskAlignment: alignment, content: content, mask: mask)
        case .mask:
            MaskSizedByMask(contentAlignment: alignment, content: content, mask: mask)
        }
        super.init(frame: .zero)

        mainView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainView)
        NSLayoutConstraint.activate([
            mainView.leftAnchor.constraint(equalTo: leftAnchor),
            mainView.rightAnchor.constraint(equalTo: rightAnchor),
            mainView.topAnchor.constraint(equalTo: topAnchor),
            mainView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
