import UIKit


public extension SomeView {

    func container(withLayoutConfiguration configure: (Container<Self>, Self) -> Void) -> Container<Self> {
        let container = Container(content: self)
        container.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false

        configure(container, self)
        return container
    }
}
