import Combine


public extension Publisher where Output == Bool {

    var inverted: some Publisher<Output, Failure> {
        self.map { !$0 }
    }
}


public prefix func !(publisher: some Publisher<Bool, Never>) -> some Publisher<Bool, Never> {
    publisher.inverted
}
