//
//  GameManager.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/11.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation

class GameModelManager {
    private var gamesCache: [Int : [GameModel]] = [:] // key为游戏mode value为[GameModel]
    
    func fetchGamesWithMode(_ mode: Int, completion: @escaping (BlockHTTPResult<[GameModel], BlockHTTPError>) -> Void) {
        
        if let cacheGames = gamesCache[mode] {
            completion(.success(cacheGames))
            return
        }
        GamesRequester.fetchGamesWithMode(mode) { [weak self] (result) in
            switch result {
            case .success(let json):
                let games = try! (json["data"] as! [String : Any]).mapModelArray(GameModel.self)
                self?.gamesCache[mode] = games
                completion(.success(games))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
