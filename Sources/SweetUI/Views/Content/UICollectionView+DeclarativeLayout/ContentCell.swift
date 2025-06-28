import UIKit


final class StaticContentReusableCollectionView<Content: UIView>: UICollectionReusableView {

    typealias ContentBuilder = (UICollectionReusableView) -> UIView

    private(set) var content: Content?


    func setContentIfNeeded(contentBuilder: @escaping (UICollectionReusableView) -> Content) {
        let hasContent = content != nil
        if hasContent { return }

        let fresh = contentBuilder(self)

        self.content = fresh
        let container = self
        container.addSubview(fresh)
        fresh.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fresh.topAnchor.constraint(equalTo: container.topAnchor),
            fresh.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            fresh.bottomAnchor.constraint(equalTo: container.bottomAnchor).priority(.almostRequired),
            fresh.trailingAnchor.constraint(equalTo: container.trailingAnchor).priority(.almostRequired),
        ])
    }
}
