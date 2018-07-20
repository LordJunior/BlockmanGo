//
//  LaunchManager.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/10.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit

class LaunchManager {
    static func launchInWindow(_ window: inout UIWindow?) {
        
        let rootController = MainNavigationController.init(rootViewController: LaunchViewController())
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = rootController
        window?.makeKeyAndVisible()
        TransitionManager.rootViewController = rootController
        TransitionManager.navigationClass = MainNavigationController.self
        
    }
}
