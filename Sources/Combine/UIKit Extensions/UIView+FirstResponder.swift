import UIKit
import Combine


public typealias FirstResponderState<T: Hashable> = AnyPublisher<T, Never>


public extension UIView {
    
    func becomesFirstResponder<F: Hashable>(
        when publisher: FirstResponderState<F>,
        isEqualTo targetValue: F
    ) -> Self {
        return becomesFirstResponder(when: publisher.map { $0 == targetValue })
    }
    
    func becomesFirstResponder(when publisher: some Publisher<Bool, Never>) -> Self{
        publisher.sink { [weak self] isFirstResponder in
            guard isFirstResponder,
                  let self else { return }
            self.becomeFirstResponder()
        }
        .store(in: .current)
        return self
    }
}
