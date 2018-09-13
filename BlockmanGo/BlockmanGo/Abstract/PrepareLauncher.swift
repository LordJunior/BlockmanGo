//
//  LaunchManager.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/10.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit

class PrepareLauncher {
    static var window: UIWindow?
    
    static func prepareRootViewController(_ window: inout UIWindow?) {
        
        let rootController = MainNavigationController.init(rootViewController: LaunchBrandingViewController())
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = rootController
        window?.makeKeyAndVisible()
        PrepareLauncher.window = window
        TransitionManager.rootViewController = rootController
        TransitionManager.navigationClass = MainNavigationController.self
        
    }
    
    static func resetRootViewControllerToLaunch(isAuthorizationExpired isExpired: Bool = true) {
        let launchController = LaunchViewController()
        launchController.isDisplayingForNormalLaunch = false
        launchController.isDisplayingForAuthorizationExpired = isExpired
        let rootController = MainNavigationController.init(rootViewController: launchController)
        window?.rootViewController = rootController
        TransitionManager.rootViewController = rootController
    }
}
