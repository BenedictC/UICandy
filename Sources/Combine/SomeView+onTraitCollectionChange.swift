import UIKit
import Combine


@MainActor
public extension SomeView {
    
    func onTraitCollectionChange<T: TraitCollectionChangesProvider>(
        of provider: T,
        _ handler: @escaping (Self, T, TraitCollectionChanges) -> Void)
    -> Self {
        let view = self
        provider.traitCollectionChanges.sink { [weak view, weak provider] publishedTraitCollection in
            guard let view, let provider else { return }
            handler(view, provider, publishedTraitCollection)
        }
        .store(in: .current)
        return self
    }
}
