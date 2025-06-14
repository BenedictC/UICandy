import Combine


public protocol CurrentValuePublisher<Output, Failure>: Publisher {

    var value: Output { get }
}


extension CurrentValueSubject: CurrentValuePublisher { }
