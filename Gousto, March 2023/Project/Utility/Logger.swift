//
//  Logger.swift
//
//  Created by Robin Macharg on 12/07/2022.
//
//  Based on YBLogger by Yogesh Bhople.
//
// See https://medium.com/@yogeshbhople/simple-logger-console-and-file-for-swift-ef968248d7fd and
//     https://github.com/yogeshbh/SimpleLogger
//
// A simple, configurable console logging class.
//
// Configured like so:
//
//     Logger.shared.configuration = COLogConfig(
//         // Only log warnings and above
//         logLevel: COLogLevel.warning,
//         display:
//             // Override the defaults for INFO logging, don't display the filename
//             .info(filename: false),
//             // Override the defaults for DEBUG logging, don't display the filename, function or line number
//             .debug(filename: false, function: false, line: false))
//     )
//
// The default configuration is .none, i.e. silent.  Configuration can be
// replaced at any point during an app's run.
//
// An .all() display parameter can be provided to set display parameters for all log levels.
// Handy to turn detailed logging on and off.
//
// swiftlint:disable comma large_tuple no_space_in_method_call line_length

import Foundation

/**
 * The basic log levels.  Logs below the configured logging level will not be reported, unless
 * force=true is supplied to the log.Level() function. Finally, console=false will turn even
 * these off.
 */
public enum COLogLevel: Int, CaseIterable {
    case debug     = 0
    case info      = 1
    case event     = 2
    case warning   = 3
    case error     = 4
    case exception = 5
    case view      = 6
    case none      = 7

    var name: String {
        switch self {
        case .debug     : return "DEBUG"
        case .info      : return "INFO"
        case .event     : return "EVENT"
        case .warning   : return "WARNING"
        case .error     : return "ERROR"
        case .exception : return "EXCEPTION"
        case .view      : return "VIEW"
        case .none      : return ""
        }
    }
}

/**
 * Describes the configuration object
 */
public protocol COLogConfigurationProtocol {
    var logLevel: COLogLevel { get }
    var filter: ((String) -> (Bool))? { get }
    var display: [COLogLevel : COLogLevelDisplay] { get }
}

/**
 * Encapsulates the information each logging level displays - timestamp, filename, line etc.,
 * in addition to the actual log message.  Also includes convenience accessors.  This resaults
 * in a modicum of boilerplate, minimised where possible.
 */
public enum COLogLevelDisplay {
    case all      (console: Bool? = true, timestamp: Bool? = true, filename: Bool? = true,  function: Bool? = true,  line: Bool? = true)
    case debug    (console: Bool? = true, timestamp: Bool? = true, filename: Bool? = true,  function: Bool? = true,  line: Bool? = true)
    case info     (console: Bool? = true, timestamp: Bool? = true, filename: Bool? = false, function: Bool? = false, line: Bool? = false)
    case event    (console: Bool? = true, timestamp: Bool? = true, filename: Bool? = true,  function: Bool? = true,  line: Bool? = true)
    case warning  (console: Bool? = true, timestamp: Bool? = true, filename: Bool? = true,  function: Bool? = true,  line: Bool? = true)
    case error    (console: Bool? = true, timestamp: Bool? = true, filename: Bool? = true,  function: Bool? = true,  line: Bool? = true)
    case exception(console: Bool? = true, timestamp: Bool? = true, filename: Bool? = true,  function: Bool? = true,  line: Bool? = true)
    case view     (console: Bool? = true, timestamp: Bool? = true, filename: Bool? = true,  function: Bool? = true,  line: Bool? = true)

    var console: Bool { destructure().console }

    var timestamp: Bool { destructure().timestamp }

    var filename: Bool { destructure().filename }

    var function: Bool { destructure().function }

    var line: Bool { destructure().line }

    /**
     * A convenience function to destructure the enum's associated values
     */
    private func destructure() -> (console: Bool, timestamp: Bool, filename: Bool, function: Bool, line: Bool) {
        switch self {
        case .all    (let console, let timestamp, let filename, let function, let line):
            return (console: console!, timestamp: timestamp!, filename: filename!, function: function!, line: line!)
        case .debug    (let console, let timestamp, let filename, let function, let line):
            return (console: console!, timestamp: timestamp!, filename: filename!, function: function!, line: line!)
        case .info     (let console, let timestamp, let filename, let function, let line):
            return (console: console!, timestamp: timestamp!, filename: filename!, function: function!, line: line!)
        case .event    (let console, let timestamp, let filename, let function, let line):
            return (console: console!, timestamp: timestamp!, filename: filename!, function: function!, line: line!)
        case .warning  (let console, let timestamp, let filename, let function, let line):
            return (console: console!, timestamp: timestamp!, filename: filename!, function: function!, line: line!)
        case .error    (let console, let timestamp, let filename, let function, let line):
            return (console: console!, timestamp: timestamp!, filename: filename!, function: function!, line: line!)
        case .exception(let console, let timestamp, let filename, let function, let line):
            return (console: console!, timestamp: timestamp!, filename: filename!, function: function!, line: line!)
        case .view     (let console, let timestamp, let filename, let function, let line):
            return (console: console!, timestamp: timestamp!, filename: filename!, function: function!, line: line!)
        }
    }
}

/**
 * Configuration for logging
 */
public struct COLogConfig : COLogConfigurationProtocol {
    public var logLevel: COLogLevel = .none
    public var filter: ((String) -> (Bool))?

    // Default display configuration
    public var display: [COLogLevel : COLogLevelDisplay] = [
        .debug     : .debug    (console: true, timestamp: true, filename: true,  function: true,  line: true),
        .info      : .info     (console: true, timestamp: true, filename: false, function: false, line: false),
        .event     : .event    (console: true, timestamp: true, filename: true,  function: true,  line: true),
        .warning   : .warning  (console: true, timestamp: true, filename: true,  function: true,  line: true),
        .error     : .error    (console: true, timestamp: true, filename: true,  function: true,  line: true),
        .exception : .exception(console: true, timestamp: true, filename: true,  function: true,  line: true),
        .view      : .exception(console: true, timestamp: true, filename: true,  function: true,  line: true)
    ]

    public init(
        logLevel: COLogLevel = .none,
        filter: ((String) -> (Bool))? = nil,
        display: COLogLevelDisplay...)
    {
        self.logLevel = logLevel
        self.filter = filter

        // Override defaults
        for level in display {
            switch level {
            // Override for all levels.  The order that COLogLevelDisplays are provided
            // in the variadic 'display' parameter is important.
            case .all:
                self.display[.debug]     = level
                self.display[.info]      = level
                self.display[.event]     = level
                self.display[.warning]   = level
                self.display[.error]     = level
                self.display[.exception] = level
                self.display[.view]      = level
            case .debug    : self.display[.debug]     = level
            case .info     : self.display[.info]      = level
            case .event    : self.display[.event]     = level
            case .warning  : self.display[.warning]   = level
            case .error    : self.display[.error]     = level
            case .exception: self.display[.exception] = level
            case .view     : self.display[.view]      = level
            }
        }
    }
}

// ------------------------------------------------------------
// MARK: - log
// Static convenience functions to make logigng simpler to write, e.g.
//     log.Warning("This is a warning", "with multiple arguments")
// ------------------------------------------------------------

public enum Log {
    public static func debug(
        _ message: Any...,
        force: Bool = false,
        callingFunctionName: String = #function,
        _ lineNumber: UInt = #line,
        _ fileName:String = #file)
    {
        Logger.shared.print(message, logLevel: .debug, callingFunctionName, lineNumber, fileName, force)
    }

    public static func info(
        _ message: Any...,
        force: Bool = false,
        callingFunctionName: String = #function,
        _ lineNumber: UInt = #line,
        _ fileName:String = #file)
    {
        Logger.shared.print(message, logLevel: .info, callingFunctionName, lineNumber, fileName, force)
    }

    public static func event(
        _ message: Any...,
        force: Bool = false,
        callingFunctionName: String = #function,
        _ lineNumber: UInt = #line,
        _ fileName:String = #file)
    {
        Logger.shared.print(message, logLevel: .event, callingFunctionName, lineNumber, fileName, force)
    }

    public static func warning(
        _ message: Any...,
        force: Bool = false,
        callingFunctionName: String = #function,
        _ lineNumber: UInt = #line,
        _ fileName:String = #file)
    {
        Logger.shared.print(message, logLevel: .warning, callingFunctionName, lineNumber, fileName, force)
    }

    public static func error(
        _ message: Any...,
        force: Bool = false,
        callingFunctionName: String = #function,
        _ lineNumber: UInt = #line,
        _ fileName:String = #file)
    {
        Logger.shared.print(message, logLevel: .error, callingFunctionName, lineNumber, fileName, force)
    }

    public static func exception(
        _ message: Any...,
        force: Bool = false,
        callingFunctionName: String = #function,
        _ lineNumber: UInt = #line,
        _ fileName:String = #file)
    {
        Logger.shared.print(message, logLevel: .exception, callingFunctionName, lineNumber, fileName, force)
    }

    public static func view(
        _ message: Any...,
        force: Bool = false,
        callingFunctionName: String = #function,
        _ lineNumber: UInt = #line,
        _ fileName:String = #file)
    {
        Logger.shared.print(message, logLevel: .view, callingFunctionName, lineNumber, fileName, force)
    }
}

// ------------------------------------------------------------
// MARK: - Logger
// A singleton that provides debug logging capability
// ------------------------------------------------------------

public final class Logger {

    // How much to indent the log level ("CO:INFO" etc.) by
    private static var levelIndent = 0

    public var configuration: COLogConfigurationProtocol

    static let shared = Logger()
    private init() {
        configuration = COLogConfig()

        // Set the indent level based on the possible values it can take
        Logger.levelIndent = (COLogLevel.allCases.map { $0.name.count }.max() ?? 0) + 4 // +4 to allow for space and arrow.
    }

    /**
     * The main logging function.  Constructs a log line based on log level and associated what-to-display values.
     */
    fileprivate func print(
        _ message: Any...,
        logLevel: COLogLevel,
        _ callingFunctionName: String = #function,
        _ lineNumber: UInt = #line,
        _ fileName: String = #file,
        _ force: Bool = false)
    {
        if logLevel.rawValue >= Logger.shared.configuration.logLevel.rawValue || force {

            let messageString = message.joined.joined.map { String(describing: $0) }.joined(separator: " ")

            var fullMessageString = Logger.symbolString(logLevel, force)

            // Display timestamp?
            if let display = Logger.shared.configuration.display[logLevel], display.timestamp {
                fullMessageString += Date().formattedISO8601 + " ⇨ "
            }

            // Display filename?
            if let display = Logger.shared.configuration.display[logLevel], display.filename {
                let fileName = URL(fileURLWithPath: fileName).deletingPathExtension().lastPathComponent
                fullMessageString += fileName + " ⇨ "
            }

            // Display function name?
            if let display = Logger.shared.configuration.display[logLevel], display.function {
                fullMessageString += callingFunctionName
                if display.line {
                    fullMessageString += " : \(lineNumber)" + " ⇨ "
                }
                else {
                    fullMessageString += " ⇨ "
                }
            }

            fullMessageString += messageString

            // Finally, print the message.  Note: forced logging can still be overridden by disabling
            // console output.  There's the possibility of adding file output here at a later date.
            if let display = Logger.shared.configuration.display[logLevel], display.console {
                if Logger.shared.configuration.filter?(fullMessageString) ?? true {
                    Swift.print(fullMessageString)
                }
            }
        }
    }

    /**
     * A convenience function that generates unicode symbols and log-level prependage
     */
    private static func symbolString(_ logLevel: COLogLevel, _ force: Bool) -> String {
        var messageString = ""
        switch logLevel {
        case .debug:     messageString = "\u{0001F539} "     // 🔹
        case .info:      messageString = "\u{0001F538} "     // 🔸
        case .event:     messageString = "\u{0001F538} "     // 🔸
        case .warning:   messageString = "\u{26A0}\u{FE0F} " // ⚠️
        case .error:     messageString = "\u{0001F6AB} "     // 🚫
        case .exception: messageString = "\u{2757}\u{FE0F} " // ❗️
        case .view:      messageString = "\u{1F4FA} "        // 📺
        case .none:      messageString = ""
        }

        var logLevelString = "LOG:\(logLevel.name)\(force ? "!" : "")"

        for _ in 0 ..< (Logger.levelIndent - logLevelString.count) {
            logLevelString.append(" ")
        }
        messageString += logLevelString + "➯ "
        return messageString
    }
}

// ------------------------------------------------------------
// MARK: - <Collection>
// Variadic flattening.  Allows us to pass in multiple unnamed
// arguments to the log function and have them formatted nicely.
// See: https://stackoverflow.com/a/47544741/2431627
// ------------------------------------------------------------

extension Collection where Element == Any {
    var joined: [Any] { flatMap { ($0 as? [Any])?.joined ?? [$0] } }
    func flatMapped<T>(_ type: T.Type? = nil) -> [T] { joined.compactMap { $0 as? T } }
}

// ------------------------------------------------------------
// MARK: - <Foundation.Date>
// Date formatter extensions
// ------------------------------------------------------------

// http://stackoverflow.com/questions/28016578/swift-how-to-create-a-date-time-stamp-and-format-as-iso-8601-rfc-3339-utc-tim
fileprivate extension Foundation.Date {
    enum Date {
        static let formatterISO8601: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: Calendar.Identifier.iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
            return formatter
        }()

        static let formatteryyyyMMdd: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: Calendar.Identifier.iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "yyyyMMdd"
            return formatter
        }()
    }
    var formattedISO8601: String { return Date.formatterISO8601.string(from: self) }
    var currentDate: String { return Date.formatteryyyyMMdd.string(from: self) }
}
