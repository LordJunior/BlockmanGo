//
//  ConfigurationNetServer.swift
//  BlockyModes
//
//  Created by KiBen on 2017/12/28.
//  Copyright © 2017年 SandboxOL. All rights reserved.
//

import UIKit
import Moya

class ConfigurationRequester {

    class func compareAppVersionFromiTunes(completion: @escaping RequestJsonCallBack) {
        return Requester.requestWithTarget(ConfigurationAPI.fetchAppInfoFromiTunes, completion: completion)
    }
    
    class func fetchAppUpdateInfo(completion: @escaping RequestJsonCallBack) {
        return Requester.requestWithTarget(ConfigurationAPI.fetchAppUpdateInfo, completion: completion)
    }
    
    class func fetchBulletin(completion: @escaping RequestJsonCallBack) {
        return Requester.requestWithTarget(ConfigurationAPI.fetchBulletin, completion: completion)
    }
}
