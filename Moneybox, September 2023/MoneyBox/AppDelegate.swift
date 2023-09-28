//
//  AppDelegate.swift
//  MoneyBox
//
//  Created by Zeynep Kara on 15.01.2022.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow? 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Note: Undiagnosed constraint errors when this is enabled.
        //       However it does give us keyboard avoidance with a single line.  Pragmatically left in.
        IQKeyboardManager.shared.enable = true
        return true
    }
}

