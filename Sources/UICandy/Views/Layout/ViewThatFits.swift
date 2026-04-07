import UIKit


public final class ViewThatFits: UIView {

    // MARK: Types

    public struct Options: OptionSet {
        public var rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static var updatesSelectionOnChangeOfSubviewBounds: Self { Self(rawValue: 1 << 0) }
        public static var `default`: Self { [] }
    }


    // MARK: Properties

    public let candidates: [UIView]
    public let alignment: ContentAlignment
    public let options: Options
    public var selectedCandidate: UIView? { selectedCandidateAndSizeConstraints?.view }
    private var selectedCandidateAndSizeConstraints: (view: UIView, width: NSLayoutConstraint, height: NSLayoutConstraint)?
    private var boundsAtLastSelection: CGRect?


    // MARK: Instance life cycle

    public init(alignment: ContentAlignment = .center, options: Options = .default, candidates: [UIView]) {
        self.candidates = candidates
        self.alignment = alignment
        self.options = options

        super.init(frame: .zero)

        for candidate in candidates {
            addSubview(candidate)
            candidate.translatesAutoresizingMaskIntoConstraints = false
            candidate.isHidden = true
        }

        let xConstraints: [NSLayoutConstraint] = switch alignment {
        case .topLeft, .left, .bottomLeft:
            candidates.map { $0.leftAnchor.constraint(equalTo: leftAnchor) }
        case .topLeading, .leading, .bottomLeading:
            candidates.map { $0.leadingAnchor.constraint(equalTo: leadingAnchor) }
        case .top, .center, .bottom, .fill:
            candidates.map { $0.centerXAnchor.constraint(equalTo: centerXAnchor) }
        case .topRight, .right, .bottomRight:
            candidates.map { $0.rightAnchor.constraint(equalTo: rightAnchor) }
        case .topTrailing, .trailing, .bottomTrailing:
            candidates.map { $0.trailingAnchor.constraint(equalTo: trailingAnchor) }
        }
        let yConstraints: [NSLayoutConstraint] = switch alignment {
        case .topLeft, .topLeading, .top, .topRight, .topTrailing:
            candidates.map { $0.topAnchor.constraint(equalTo: topAnchor) }
        case .left, .leading, .center, .right, .trailing, .fill:
            candidates.map { $0.centerYAnchor.constraint(equalTo: centerYAnchor) }
        case .bottomLeft, .bottomLeading, .bottom, .bottomRight, .bottomTrailing:
            candidates.map { $0.bottomAnchor.constraint(equalTo: bottomAnchor) }
        }

        let positionalConstraints = xConstraints + yConstraints
        NSLayoutConstraint.activate(positionalConstraints)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: Layout

    public override func layoutSubviews() {
        let bounds = self.bounds
        let size = bounds.size

        defer { boundsAtLastSelection = bounds }

        // # Can we bale?
        let onlyUpdateOnBoundsChange = !options.contains(.updatesSelectionOnChangeOfSubviewBounds)
        if onlyUpdateOnBoundsChange {
            let stale = boundsAtLastSelection ?? .zero
            let fresh = bounds
            let isNoChange = fresh == stale
            if isNoChange {
                return
            }
        }

        // # Find the best match
        var match: (view: UIView, size: CGSize)?
        for candidate in candidates {
            let candidateSize = candidate.systemLayoutSizeFitting(
                UIView.layoutFittingCompressedSize,
                withHorizontalFittingPriority: .fittingSizeLevel,
                verticalFittingPriority: .fittingSizeLevel
            )
            let isCandidateSuccessful = candidateSize.width <= size.width && candidateSize.height <= size.height
            if isCandidateSuccessful {
                match = (candidate, candidateSize)
                break
            }
        }
        if match == nil, let lastCandidate = candidates.last {
            // We use the self.size which means the constraints failures will be in the selected view.
            match = (lastCandidate, size)
        }

        // # Remove the stale view
        if let selectedCandidate {
            let isAlreadyConfigured = selectedCandidate == match?.view
            if isAlreadyConfigured, let size = match?.size {
                selectedCandidateAndSizeConstraints?.width.constant = size.width
                selectedCandidateAndSizeConstraints?.height.constant = size.height
                return
            }
            // Reset selectedCandidate
            selectedCandidateAndSizeConstraints?.view.isHidden = true
            selectedCandidateAndSizeConstraints?.width.isActive = false
            selectedCandidateAndSizeConstraints?.height.isActive = false
            self.selectedCandidateAndSizeConstraints = nil
        }

        // # Install the new view
        guard let match else {
            return
        }
        match.view.isHidden = false
        let widthConstraint = match.view.widthAnchor.constraint(equalToConstant: match.size.width)
        widthConstraint.priority = .defaultHigh
        widthConstraint.isActive = true
        let heightConstraint = match.view.heightAnchor.constraint(equalToConstant: match.size.height)
        heightConstraint.priority = .defaultHigh
        heightConstraint.isActive = true

        selectedCandidateAndSizeConstraints = (view: match.view, width: widthConstraint, height: heightConstraint)
    }
}


// MARK: - Declarative style

public extension ViewThatFits {

    convenience init(alignment: ContentAlignment = .center, options: Options = .default, @SubviewsBuilder candidatesBuilder: () -> [UIView]) {
        let candidates = candidatesBuilder()
        self.init(alignment: alignment, options: options, candidates: candidates)
    }
}

