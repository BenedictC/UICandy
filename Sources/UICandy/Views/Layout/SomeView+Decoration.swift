import UIKit


public extension SomeView {

    typealias DecorationContainer<V: UIView, O: UIView> = Container<(view: V, overlay: O)>
}


// MARK: - Overlay

public extension SomeView {

    func overlay<O: UIView>(alignment: DecorationAlignment, view: O) -> DecorationContainer<Self, O> {
        overlay(alignment: alignment, view: { view })
    }

    func overlay<O: UIView>(alignment: DecorationAlignment, view overlayBuilder: () -> O) -> DecorationContainer<Self, O> {
        let overlay = overlayBuilder()
        let container = DecorationContainer(content: (self, overlay))

        self.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(self)
        NSLayoutConstraint.activate([
            self.leftAnchor.constraint(equalTo: container.leftAnchor),
            self.rightAnchor.constraint(equalTo: container.rightAnchor),
            self.topAnchor.constraint(equalTo: container.topAnchor),
            self.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])

        overlay.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(overlay)
        let overlayConstraints = alignment.makeConstraints(base: self, decoration: overlay)
        NSLayoutConstraint.activate(overlayConstraints)

        return container
    }
}


// MARK: - Background

public extension SomeView {

    func background<O: UIView>(alignment: DecorationAlignment = .fill, view: O) -> DecorationContainer<Self, O> {
        background(alignment: alignment, view: { view })
    }

    func background<O: UIView>(alignment: DecorationAlignment = .fill, view backgroundBuilder: () -> O) -> DecorationContainer<Self, O> {
        let background = backgroundBuilder()
        let container = DecorationContainer(content: (self, background))

        self.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(self)
        NSLayoutConstraint.activate([
            self.leftAnchor.constraint(equalTo: container.leftAnchor),
            self.rightAnchor.constraint(equalTo: container.rightAnchor),
            self.topAnchor.constraint(equalTo: container.topAnchor),
            self.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])

        background.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(background)
        container.sendSubviewToBack(background)
        let overlayConstraints = alignment.makeConstraints(base: self, decoration: background)
        NSLayoutConstraint.activate(overlayConstraints)

        return container
    }
}
