//
//  GameDetailModel.swift
//  BlockyModes
//
//  Created by KiBen Hung on 2018/2/6.
//  Copyright © 2018年 SandboxOL. All rights reserved.
//

import Foundation
import HandyJSON

/*
 "gameId": "g1001",
 "gameTitle": "饥饿游戏",
 "bannerPic": [
 "http://static.sandboxol.cn/games/images/g1001.饥饿游戏2.1511408908056.png"
 ],
 "gameDetail": "这是一款跟电影《饥饿游戏》相似的手机游戏。每一位玩家在基石重生，并目标成为最后的玩家。同一时间最多支持24位玩家。为了生存下去，用武器把其他玩家杀光成为最后的胜者。\"",
 "onlineNumber": 0,
 "praiseNumber": 6,
 "gameCoverPic": "http://static.sandboxol.cn/games/images/g1001.饥饿游戏.1511408866612.png",
 "gameTypes": [
 "PVP",
 "冒险"
 ],
 "appreciate": false
 "visitorEnter": 0
 */

struct GameDetailModel: HandyJSON {
    
    var gameID: String = ""
    var gameCoverPic: String = ""
    var gameTitle: String = ""
    var gameTypes: [String] = []
    var praiseNumber: Int = 0
    var appreciate: Bool = false
    var bannerPic: [String] = []
    var gameDetail: NSAttributedString = NSAttributedString(string: "")
    var visitorEnter: Int = 0
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.gameDetail <-- TransformOf<NSAttributedString, String>(fromJSON: { detail -> NSAttributedString in
                let paraStyle = NSMutableParagraphStyle()
                paraStyle.alignment = .left
                paraStyle.lineSpacing = 10
                let attributes: [NSAttributedStringKey : Any] = [NSAttributedStringKey.foregroundColor : R.clr.appColor._653e00(), NSAttributedStringKey.font : UIFont.size11, NSAttributedStringKey.paragraphStyle : paraStyle]
                return NSAttributedString.init(string: detail ?? "", attributes: attributes)
            }, toJSON: { attributedDetail -> String? in
                attributedDetail?.string
            })
    }
}
