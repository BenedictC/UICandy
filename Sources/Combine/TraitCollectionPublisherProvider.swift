import UIKit
import Combine


public typealias TraitCollectionChanges = (previous: UITraitCollection?, current: UITraitCollection)


public protocol TraitCollectionChangesProvider: AnyObject {

    var traitCollectionChanges: AnyPublisher<TraitCollectionChanges, Never> { get }
}


// MARK: - TraitCollectionChangesController (Internal implementation helper)

class TraitCollectionChangesController {

    @Published private var _traitCollectionChanges: TraitCollectionChanges
    var traitCollectionChanges: AnyPublisher<TraitCollectionChanges, Never> { $_traitCollectionChanges.eraseToAnyPublisher() }

    init(initialTraitCollection: UITraitCollection) {
        self._traitCollectionChanges = (nil, initialTraitCollection)
    }

    func send(previous: UITraitCollection?, current: UITraitCollection) {
        _traitCollectionChanges = (previous, current)
    }
}
