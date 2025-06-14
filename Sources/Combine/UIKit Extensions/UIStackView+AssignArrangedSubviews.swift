import UIKit
import Combine

@MainActor
public extension SomeView where Self: UIStackView {

    func assignArrangedSubviews<V: UIView>(from publisher: some Publisher<([V]?), Never>) -> Self {
        let stackView = self
        publisher.sink { [weak stackView] views in
            guard let stackView else { return }
            // TODO: Do we need to implement a smart approach to this or will the stackView take care of it?
            stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            views?.forEach { stackView.addArrangedSubview($0) }
        }
        .store(in: .current)
        return self
    }
}
