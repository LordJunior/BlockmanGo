//
//  ThirdPartyService.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/8/17.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation

struct ThirdPartyService {
    private init() {
        
    }
    
    static func initialize(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
#if DEBUG
#else
        AnalysisService.start() // 启动统计服务
#endif
    }
}
