import Foundation


@_transparent
@inline(__always)
@usableFromInline
func detectPotentialRetainCycle<T>(of object: CFTypeRef, advice: String? = nil, performing work: () -> T) -> T {
    let expectedCount = CFGetRetainCount(object)
    let result = autoreleasepool {
        work()
    }
    let actualCount = CFGetRetainCount(object)

    if actualCount != expectedCount {
        let increment = actualCount - expectedCount
        let message = [
            "⚠️ Potential retain cycle of **\(type(of: object))** detected. Retain count incremented by \(increment).",
            advice,
            "This may be a false positive caused by a transient retain, e.g. a Task, DispatchQueue or Operation.",
        ]
            .compactMap { $0 }
            .joined(separator: "\n")
        runtimeWarn(message)
    }

    return result
}
