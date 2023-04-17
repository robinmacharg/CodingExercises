//
//  FlowwExerciseApp.swift
//  FlowwExercise
//
//  Created by Robin Macharg on 12/04/2023.
//

import SwiftUI

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        // Configure console logging.  The Logger class has detailed documentation.
        Logger.shared.configuration = FWLogConfig(logLevel: FWLogLevel.debug)
        return true
    }
}

@main
struct FlowwExerciseApp: App {

    // Use the traditional app delegate to configure logging.  _delegate is unused.
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var _delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
