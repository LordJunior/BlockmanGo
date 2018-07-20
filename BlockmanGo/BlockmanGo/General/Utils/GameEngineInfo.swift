//
//  GameEngine.swift
//  BlockyModes
//
//  Created by KiBen on 2018/1/22.
//  Copyright © 2018年 SandboxOL. All rights reserved.
//

import Foundation

struct GameEngineInfo {
    
    public static var engineVersion: Int32  {
        get {
            var bundlePath = Bundle.main.resourcePath!
            bundlePath.append("/EngineResource/Media/engineVersion.json")
            guard let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: bundlePath)) else {
                return 10010
            }
            let engineVersionDict = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any]
            return engineVersionDict["engineVersion"] as! Int32
        }
    }
    
    public static var resourceVersion: String  {
        get {
            var bundlePath = Bundle.main.resourcePath!
            bundlePath.append("/EngineResource/resVersion.json")
            guard let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: bundlePath)) else {
                return AppInfo.currentShortVersion
            }
            let resourceVersionDict = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any]
            return resourceVersionDict["version"] as! String
        }
    }
}
