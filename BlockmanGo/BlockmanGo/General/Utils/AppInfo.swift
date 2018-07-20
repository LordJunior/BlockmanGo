//
//  AppInfo.swift
//  BlockyModes
//
//  Created by KiBen on 2017/12/28.
//  Copyright © 2017年 SandboxOL. All rights reserved.
//

import Foundation

struct AppInfo {
    
    static var currentShortVersion: String {
        get {
            let appInfoDict = Bundle.main.infoDictionary!
            return appInfoDict["CFBundleShortVersionString"] as! String
        }
    }
    
    static var currentBuildVersion: String {
        get {
            let appInfoDict = Bundle.main.infoDictionary!
            return appInfoDict["CFBundleVersion"] as! String
        }
    }
}
