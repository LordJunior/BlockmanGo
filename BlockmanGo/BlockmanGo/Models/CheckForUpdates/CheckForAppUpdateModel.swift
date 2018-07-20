//
//  CheckForAppUpdateModel.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/17.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation
import HandyJSON

/*
 "isForceUpdate": true,
 "version": "1.0.0",
 "downloadURL": "itms-apps://itunes.apple.com/cn/app/id1335948169?mt=8",
 "minAvailableVersion": "",
 "needToForceUpdateVersions": []
 */

struct CheckForAppUpdateModel: HandyJSON {
    var isForceUpdate: Bool = false
    var version: String = ""
    var downloadURL: String = ""
    var minAvailableVersion: String = ""
    var needToForceUpdateVersions: [String] = []
}
