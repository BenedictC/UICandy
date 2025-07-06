import os.log
import Foundation


// MARK: - print override

@available(*, deprecated, message: "Use log.info/debug/error/fault instead.")
internal func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    let message = SweetUILogger.makeMessage(items, separator: separator, terminator: terminator)
    Swift.print(message)
}


// MARK: - Logger

let log = SweetUILogger()


struct SweetUILogger {

    // MARK: Properties

    private static let osLog = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "SweetUI", category: "SweetUI")

    
    // MARK: Message creation

    static func makeMessage(_ items: [Any], separator: String, terminator: String) -> String {
        items
            .map { "\($0)" }
            .joined(separator: separator)
        + terminator
    }


    // MARK: Logging

    func info(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        log(type: .info, items, separator: separator, terminator: terminator)
    }

    func debug(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        log(type: .debug, items, separator: separator, terminator: terminator)
    }

    func error(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        log(type: .error, items, separator: separator, terminator: terminator)
    }

    func fault(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        log(type: .fault, items, separator: separator, terminator: terminator)
    }

    private func log(type: OSLogType, _ items: [Any], separator: String = " ", terminator: String = "\n") {
        let message = Self.makeMessage(items, separator: separator, terminator: terminator)
        os_log(type, log: Self.osLog, "%@", message)
    }
}
