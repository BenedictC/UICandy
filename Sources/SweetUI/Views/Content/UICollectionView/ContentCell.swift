import UIKit


final class ContentCell<Content: UIView>: UICollectionViewCell {

    private(set) var content: Content?

    var hasContent: Bool { content != nil }

    func replaceContent(_ contentBuilder: (UICollectionViewCell, Content?) -> Content) {
        let stale = self.content

        let fresh = contentBuilder(self, stale)

        if stale != fresh {
            stale?.removeFromSuperview()
            self.content = fresh
            let container = self.contentView
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
}
