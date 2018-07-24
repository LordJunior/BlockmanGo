//
//  GameDispatchModel.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/24.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation
import HandyJSON

struct GameDispatchModel: HandyJSON {
    var dispatchURL: String = ""
    var token: String = ""
    var nickname: String = ""
    var signature: String = ""
    var region: Int32 = 0
    var timestamp: UInt64 = 0
    var gameAddr: String = ""
    var mapName: String = ""
    var mapURL: String = ""
    var mapID: String = ""
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.nickname <-- "name"
        
        mapper <<<
            self.dispatchURL <-- "dispUrl"
        
        mapper <<<
            self.gameAddr <-- "gaddr"
        
        mapper <<<
            self.mapName <-- "mname"
        
        mapper <<<
            self.mapURL <-- "downurl"
        
        mapper <<<
            self.mapID <-- "mid"
    }
}
