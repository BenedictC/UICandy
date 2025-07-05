@resultBuilder
public struct ArrayBuilder<Element> {

    public static func buildExpression(_ expression: Element?) -> [Element] {
        [expression].compactMap { $0 }
    }

    public static func buildExpression(_ expression: [Element]?) -> [Element] {
        (expression ?? [])
    }

    public static func buildBlock(_ components: [Element]...) -> [Element] {
        components.reduce([], +)
    }

    public static func buildArray(_ components: [[Element]]) -> [Element] {
        components.reduce([], +)
    }

    public static func buildOptional(_ component: [Element]?) -> [Element] {
        component ?? []
    }

    public static func buildEither(first component: [Element]) -> [Element] {
        component
    }

    public static func buildEither(second component: [Element]) -> [Element] {
        component
    }
}


//    // MARK: - Generic Sequence variants
//
//    public static func buildExpression<S: Sequence>(_ expression: S) -> [Element] where S.Element == Element {
//        toArray(expression)
//    }
//
//    public static func buildBlock<S: Sequence>(_ components: S...) -> [Element] where S.Element == Element {
//        components.reduce([], +)
//    }
//
//    public static func buildArray<S: Sequence>(_ components: [S]) -> [Element] where S.Element == Element {
//        components.reduce([], +)
//    }
//
//    public static func buildOptional<S: Sequence>(_ component: S?) -> [Element] where S.Element == Element {
//        component.flatMap { toArray($0) } ?? []
//    }
//
//    public static func buildEither<S: Sequence>(first component: S) -> [Element] where S.Element == Element {
//        toArray(component)
//    }
//
//    public static func buildEither<S: Sequence>(second component: S) -> [Element] where S.Element == Element {
//        toArray(component)
//    }
//}
//
//
//private func toArray<S: Sequence>(_ s: S) -> [S.Element] {
//    s as? [S.Element] ?? Array(s)
//}
