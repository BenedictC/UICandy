import Combine


// MARK: - ValuePublishingCell
@available(*, deprecated)
internal final class ValuePublishingCell<Value>: UICollectionViewCell, ReusableViewConfigurable, CancellableStorageProvider {

    // MARK: Properties

    typealias BodyProvider = ((UICollectionViewCell, any CurrentValuePublisher<Value, Never>) -> UIView)


    // MARK: Properties

    let cancellableStorage = CancellableStorage()
    private var bodyProvider: BodyProvider?
    private var valueSubject: CurrentValueSubject<Value, Never>!


    // MARK: - ReusableViewConfigurable

    func initialize(bodyProvider: @escaping BodyProvider) {
        self.bodyProvider = bodyProvider
    }

    func configure(withValue freshValue: Value) {
        let isInitialized = valueSubject != nil
        if isInitialized {
            self.valueSubject.send(freshValue)
            return
        }

        // Create binding and body
        CancellableStorage.push(cancellableStorage)
        defer { CancellableStorage.pop(expected: cancellableStorage) }

        self.valueSubject = CurrentValueSubject(freshValue)
        guard let bodyProvider else {
            preconditionFailure("Misconfigured cell")
        }
        let body = bodyProvider(self, valueSubject)

        self.contentView.addSubview(body)
        body.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            body.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            body.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            body.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor).priority(.almostRequired),
            body.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor).priority(.almostRequired),
        ])
    }
}
