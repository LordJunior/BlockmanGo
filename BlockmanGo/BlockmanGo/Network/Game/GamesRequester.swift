//
//  GamesRequester.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/12.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation

struct GamesRequester {
    static func fetchGamesWithMode(_ mode: Int, completion: @escaping RequestJsonCallBack) {
        Requester.requestWithTarget(GamesAPI.gamesList(mode), completion: completion)
    }
    
    static func fetchGameDetails(gameID: String, completion: @escaping RequestJsonCallBack) {
        Requester.requestWithTarget(GamesAPI.gameDetailInfo(gameID), completion: completion)
    }
    
    static func likesGame(gameID: String, completion: @escaping RequestJsonCallBack) {
        Requester.requestWithTarget(GamesAPI.appreciate(gameID), completion: completion)
    }
}
