import Combine


public func combine<Output1, Output2, Failure>(
    _ publisher1: some Publisher<Output1, Failure>,
    _ publisher2: some Publisher<Output2, Failure>
) -> some Publisher<(Output1, Output2), Failure> {
    Publishers.CombineLatest(publisher1, publisher2)
}


public func combine<Output1, Output2, Output3, Failure>(
    _ publisher1: some Publisher<Output1, Failure>,
    _ publisher2: some Publisher<Output2, Failure>,
    _ publisher3: some Publisher<Output3, Failure>
) -> some Publisher<(Output1, Output2, Output3), Failure> {
    Publishers.CombineLatest3(publisher1, publisher2, publisher3)
}


public func combine<Output1, Output2, Output3, Output4, Failure>(
    _ publisher1: some Publisher<Output1, Failure>,
    _ publisher2: some Publisher<Output2, Failure>,
    _ publisher3: some Publisher<Output3, Failure>,
    _ publisher4: some Publisher<Output4, Failure>
) -> some Publisher<(Output1, Output2, Output3, Output4), Failure> {
    Publishers.CombineLatest4(publisher1, publisher2, publisher3, publisher4)
}
