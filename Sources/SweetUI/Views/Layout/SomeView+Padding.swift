import UIKit


// MARK: - Absolute

public extension SomeView {

    func padding(_ insets: UIEdgeInsets) -> Container<Self> {
        let group = Container(content: self)
        group.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: group.topAnchor, constant: insets.top),
            bottomAnchor.constraint(equalTo: group.bottomAnchor, constant: -insets.bottom),
            leftAnchor.constraint(equalTo: group.leftAnchor, constant: insets.left),
            rightAnchor.constraint(equalTo: group.rightAnchor, constant: -insets.right),
        ])
        return group
    }

    func padding(_ inset: CGFloat) -> Container<Self> {
        padding(UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
    }

    func padding(vertical: CGFloat, horizontal: CGFloat = 0) -> Container<Self> {
        padding(UIEdgeInsets(top: vertical, left: horizontal, bottom: vertical, right: horizontal))
    }

    func padding(horizontal: CGFloat) -> Container<Self> {
        let vertical = CGFloat(0)
        return padding(UIEdgeInsets(top: vertical, left: horizontal, bottom: vertical, right: horizontal))
    }

    func padding(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> Container<Self> {
        padding(UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
    }
}


// MARK: - Directional

public extension SomeView {

    func padding(_ insets: NSDirectionalEdgeInsets) -> Container<Self> {
        let group = Container(content: self)
        group.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: group.topAnchor, constant: insets.top),
            bottomAnchor.constraint(equalTo: group.bottomAnchor, constant: -insets.bottom),
            leadingAnchor.constraint(equalTo: group.leadingAnchor, constant: insets.leading),
            trailingAnchor.constraint(equalTo: group.trailingAnchor, constant: -insets.trailing),
        ])
        return group
    }

    func padding(top: CGFloat = 0, leading: CGFloat, bottom: CGFloat = 0, trailing: CGFloat = 0) -> Container<Self> {
        padding(NSDirectionalEdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing))
    }

    func padding(top: CGFloat = 0, /*leading: CGFloat = 0 ,*/ bottom: CGFloat = 0, trailing: CGFloat) -> Container<Self> {
        padding(NSDirectionalEdgeInsets(top: top, leading: 0, bottom: bottom, trailing: trailing))
    }
}
