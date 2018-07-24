//
//  GameModel.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/12.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation
import HandyJSON

/*
 "gameId": "g1001",
 "gameTitle": "饥饿游戏",
 "gameDetail": "这是一款跟电影《饥饿游戏》相似的手机游戏。每一位玩家在基石重生，并目标成为最后的玩家。同一时间最多支持24位玩家。为了生存下去，用武器把其他玩家杀光成为最后的胜者。\"",
 "onlineNumber": 0,
 "praiseNumber": 6,
 "gameCoverPic": "http://static.sandboxol.cn/games/images/g1001.饥饿游戏.1511408866612.png",
 "gameTypes": [
 "PVP",
 "冒险"
 ],
 "version": 0
 "visitorEnter": 0
 */

struct GameModel: HandyJSON {
    var gameId: String = ""
    var gameCoverPic: String = ""
    var gameTitle: String = ""
    var gameTypes: [String] = []
    var praiseNumber: Int = 0
    var onlineNumber: Int = 0
    var version: Int = 0
    var visitorEnter: Bool = false
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.visitorEnter <-- TransformOf<Bool, Int>(fromJSON: { visitorEnter -> Bool in
                guard let visitorEnter = visitorEnter else {
                    return false
                }
                return visitorEnter == 1
            }, toJSON: { visitorEnter -> Int in
                guard let visitorEnter = visitorEnter else {
                    return 0
                }
                return visitorEnter ? 1 : 0
            })
    }
}
