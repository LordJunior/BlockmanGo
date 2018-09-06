//
//  AppDelegate.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/4.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        PrepareLauncher.prepareRootViewController(&window)
        ThirdPartyService.initialize(application: application, launchOptions: launchOptions)
        BMUserDefaults.setString(AppInfo.currentShortVersion, forKey: .appShortVersion)
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        FacebookSignService.applicationDidBecomeActive(application)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        guard let source = options[.sourceApplication] as? String else {return false}
        if source.contains("fbapi") || source.contains("fbauth2") {
            return FacebookSignService.application(app, open: url, options: options)
        }
        return GoogleSignService.application(app, open: url, options: options)
    }
}

