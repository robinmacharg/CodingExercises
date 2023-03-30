//
//  PulseliveApp.swift
//  Pulselive
//
//  Created by Robin Macharg on 28/03/2023.
//
// swiftlint:disable opening_brace
//

/**
 * A two screen coding exercise that shows a list of articles and allows tapping through to a detail view of a
 * specific article.
 */

import SwiftUI

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        // Configure console logging.  The Logger class has detailed documentation.
        Logger.shared.configuration = PLLogConfig(logLevel: PLLogLevel.debug)
        return true
    }
}

@main
struct PulseliveApp: App {

    // Use the traditional app delegate to configure logging.  _delegate is unused.
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var _delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
