import Foundation
import Combine
import UIKit


public extension UISegmentedControl {
    
    // TODO: Should this take a subject instead of a publisher?
    func selectedSegmentIndex(_ publisher: some Publisher<Int, Never>) -> Self {
        publisher.sink { [weak self] index in
            guard let self else { return }
            guard self.selectedSegmentIndex != index else { return }
            guard (-1..<(self.numberOfSegments)).contains(index) else {
                log.error("Published value '\(index)' is out of range for selectedSegmentIndex of '\(self)'.")
                return
            }
            self.selectedSegmentIndex = index
        }
        .store(in: CancellableStorage.current)
        return self
    }
    
    // TODO: Should this take a subject instead of a publisher?
    func selectedSegmentIndex(_ initialPublisher: some Publisher<Int?, Never>) -> Self {
        let publisher = initialPublisher.map { $0 ?? UISegmentedControl.noSegment }
        return selectedSegmentIndex(publisher)
    }
    
    //    func selectedSegmentIndex(
    //        _ subject: some Subject<Int, Never>,
    //        cancellableStorageProvider optionalCancellableStorageProvider: CancellableStorageProvider? = nil
    //    ) -> Self {
    //        let cancellable = SelectedSegmentIndexReceiver.shared.bindIndexSelection(of: self, to: subject)
    //        let cancellableStorageProvider = CancellableStorage.current
    //        cancellableStorageProvider.storeCancellable(cancellable, self)
    //        return self
    //    }
}


private class SelectedSegmentIndexReceiver {
    
    static let shared = SelectedSegmentIndexReceiver()
    
    private var subjectsByControl = NSMapTable<UISegmentedControl, NSMutableSet>.weakToStrongObjects()
    
    private func subjects(for control: UISegmentedControl) -> NSMutableSet {
        if let existing = subjectsByControl.object(forKey: control) {
            return existing
        }
        let subjects = NSMutableSet()
        subjectsByControl.setObject(subjects, forKey: control)
        return subjects
    }
    
    func bindIndexSelection(of control: UISegmentedControl, to subject: some Subject<Int, Never>) -> AnyCancellable {
        let anySubject = subject.eraseToAnySubject()
        // Store the subject
        subjects(for: control).add(anySubject)
        
        // Add the target
        control.addTarget(self, action: #selector(sendSelectedSegmentIndex(_:)), for: .valueChanged)
        let sendCancellable = AnyCancellable {
            control.removeTarget(self, action: #selector(self.sendSelectedSegmentIndex(_:)), for: .valueChanged)
        }
        // Receive values from subject
        let receiveCancellable = subject.sink { [weak control] index in
            guard let control else { return }
            guard control.selectedSegmentIndex != index else { return }
            guard (-1..<(control.numberOfSegments)).contains(index) else {
                log.error("Published value '\(index)' is out of range for selectedSegmentIndex of '\(control)'.")
                return
            }
            control.selectedSegmentIndex = index
        }
        
        return AnyCancellable {
            [sendCancellable, receiveCancellable].forEach { $0.cancel() }
        }
    }
    
    @objc
    private func sendSelectedSegmentIndex(_ sender: Any?) {
        guard let control = sender as? UISegmentedControl else {
            return
        }
        let newValue = control.selectedSegmentIndex
        subjects(for: control)
            .compactMap { $0 as? AnySubject<Int, Never> }
            .forEach { $0.send(newValue) }
    }
}
