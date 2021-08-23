//
//  main.swift
//  SimpleCron
//
//  Created by Robin Macharg on 09/08/2021.
//
// Read a simplified crontab-format file from stdin and, taking a supplied 24hr time, generate the next time that
// each line of the crontab would run its command.
//
// Example usage:
//
// $ cat input.crontab | swift main.swift 16:10

import Foundation

// MARK: - Supporting data structures

let minuteRange = [Int](0...59)
let hourRange = [Int](0...23)

/**
 * Represents the type of error that can occur at an application level, with associated result codes
 */
enum ApplicationError: Int32, Error {
    case invalidArgument = 1
    case invalidCrontab = 2
    case algorithmic = 3
}

/**
 * A relative day value - today or tomorrow
 */
enum RelativeDay: String {
    case today = "today"
    case tomorrow = "tomorrow"
}

/**
 * Represents a crontab time specification: minutes or hours.  A wildcard ('*') can also be represented
 */
enum CronTime {
    enum TimeType {
        case minute
        case hour
    }
    case number(Int)
    case wildcard

    /// The hour or minutes as an optional Int, or nil for wildcard
    var intValue: Int? {
        switch self {
        case .number(let value):
            return value
        default:
            return nil
        }
    }
}

extension CronTime {
    
    enum CronTimeError: Error {
        case invalidNumber(_ string: String)
    }
    
    // Validate and initialize a CronTime from a string
    init(type: TimeType, value: String) throws {
        switch value {
        case "*":
            self = .wildcard

        // Parse a string to Int, constrained by whether it represents hours or minutes
        case _ where Int(value) != nil:
            guard let intValue = Int(value),
                  type == .minute
                    ? (0..<60).contains(intValue)
                    : (0..<24).contains(intValue) else
            {
                throw CronTimeError.invalidNumber(value)
            }
            self = .number(intValue)
        
        default:
            throw CronTimeError.invalidNumber(value)
        }
    }
}

/**
 * Represents a single line of a simplified Crontab file
 */
struct CronEntry {
    
    enum CronEntryError: Error {
        case invalidCronEntry
    }
    
    let minutes: CronTime
    let hour: CronTime
    let command: String
}

// MARK: - Helper Functions

/**
 * Read stdin and return as an array of lines
 */
func readLinesFromStdIn() -> [String] {
    var lines: [String] = []
    while let line = readLine() {
        lines.append(line)
    }
    return lines
}

/**
 * Parse a 24hr time string into an (hours, minutes) tuple
 */
func parseCurrentTime() throws -> CurrentTime {
    if CommandLine.arguments.count == 2 {
        let components = CommandLine.arguments[1].components(separatedBy: ":")
        if components.count == 2 {
            return (
                try CronTime(type: .hour, value: components[0]),
                try CronTime(type: .minute, value: components[1]))
        }
    }

    throw ApplicationError.invalidArgument
}

/**
 * Read a simplified crontab from stdin
 */
func parseCronTab(_ lines: [String]) throws -> [CronEntry] {
    var crontab: [CronEntry] = []

    for line in lines {
        // Ignore whitespace-only lines
        if line.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            continue
        }

        // Exit if there's a parsing failure
        guard let cronEntry = try? parseLine(line) else {
            throw ApplicationError.invalidCrontab
        }
        crontab.append(cronEntry)
    }
    return crontab
}

/**
 * Parse a line of a text crontab into a structure
 */
func parseLine(_ line: String) throws -> CronEntry {
    // Condense multiple whitespaces between elements
    let components = line.components(separatedBy: .whitespaces).filter { $0.count > 0}

    if components.count >= 3 {
        if let minutes = try? CronTime.init(type: .minute, value: components[0]),
           let hour = try? CronTime.init(type: .hour, value: components[1])
            {
            let command = components[2...].joined(separator: " ")
            return CronEntry(minutes: minutes, hour: hour, command: command)
        }
    }

    // Fallthrough
    throw CronEntry.CronEntryError.invalidCronEntry
}

// MARK: - Main algorithm

/// A named tuple type to represent the current time
typealias CurrentTime = (hour: CronTime, minutes: CronTime)

/// The supplied "current" time
var currentTime: CurrentTime

/// Stores the crontab
var crontab: [CronEntry]

// The main application logic
do {

    // MARK: - Handle inputs

    do {
        currentTime = try parseCurrentTime()
    }
    catch {
        throw ApplicationError.invalidArgument
    }

    do {
        var lines: [String]
        lines = readLinesFromStdIn()
        crontab = try parseCronTab(lines)
    }
    catch {
        throw ApplicationError.invalidCrontab
    }

    // MARK: - Generate the output

    let currentHour = currentTime.hour.intValue!
    let currentMinutes = currentTime.minutes.intValue!

    for line in crontab {
        var resolvedHour: Int = -1
        var resolvedMinutes: Int = -1
        var relativeDay: RelativeDay = .today
        let nowTimeInMinutes = currentHour * 60 + currentMinutes

        // There are four cases to handle
        switch (line.hour, line.minutes) {

        // Fixed time; decide if it's in the future or past
        case (.number(let lineHour), .number(let lineMinutes)):
            resolvedHour = lineHour
            resolvedMinutes = lineMinutes

            let lineTimeInMinutes = lineHour * 60  + lineMinutes


            if lineTimeInMinutes < nowTimeInMinutes {
                relativeDay = .tomorrow
            }

        // Two wildcards - run now
        case (.wildcard, .wildcard):
            resolvedHour = currentHour
            resolvedMinutes = currentMinutes

        // Wildcard hour, fixed minutes
        case (.wildcard, .number(let minutes)):
            resolvedMinutes = minutes
            resolvedHour = currentHour
            let totalResolvedMinutes = resolvedHour * 60 + resolvedMinutes
            // In the past, advance an hour, mod 24, detect rollover
            if totalResolvedMinutes < nowTimeInMinutes {
                resolvedHour = (resolvedHour + 1) % 24
                if resolvedHour * 60 + resolvedMinutes < nowTimeInMinutes {
                    relativeDay = .tomorrow
                }
            }

        // Fixed hour, Wildcard minute
        case (.number(let hour), .wildcard):
            resolvedHour = hour
            resolvedMinutes = currentMinutes
            if hour != currentHour {
                resolvedMinutes = 0
            }

            if resolvedHour * 60 + resolvedMinutes < nowTimeInMinutes {
                relativeDay = .tomorrow
            }
        }

        // Algorithmic consistency checks
        if resolvedHour == -1 || resolvedMinutes == -1 {
            throw ApplicationError.algorithmic
        }

        // Output.  Format:
        // H:MM DAY - TASK
        print("\(resolvedHour):\(String(format: "%02d", resolvedMinutes)) \(relativeDay.rawValue) - \(line.command)")

        // If 24-hour HH:MM format is required comment out the previous line and uncomment the next line
        //        print("\(String(format: "%02d", resolvedHour)):\(String(format: "%02d", resolvedMinutes)) \(relativeDay.rawValue) - \(line.command)")
    }
}

// Catch any errors and expose them via the scripts exit value
catch let e as ApplicationError {
    exit(e.rawValue)
}

