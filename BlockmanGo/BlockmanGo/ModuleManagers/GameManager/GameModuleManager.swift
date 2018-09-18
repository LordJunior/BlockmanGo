//
//  GameManager.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/11.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation

class GameModuleManager {
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
    
    func enterGame(_ gameID: String, completion: @escaping (BlockHTTPResult<GameDispatchModel, BlockHTTPError>) -> Void) {
        GamesRequester.fetchEnterGameToken(gameID: gameID) { [weak self] (result) in
            switch result {
            case .success(let response):
                if var tokenDict = response["data"] as? [String : Any], !tokenDict.isEmpty {
                    dispatchEnterGameHost = tokenDict["dispUrl"] as! String
                    self?.dispatchEnterGameResource(tokenDict: tokenDict, completion: completion)
                }else {
                    completion(.failure(.unknown))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func dispatchEnterGameResource(tokenDict: [String : Any], completion: @escaping (BlockHTTPResult<GameDispatchModel, BlockHTTPError>) -> Void) {
        GamesRequester.dispatchEnterGameResource(token: tokenDict["token"] as! String, region: tokenDict["region"] as! Int) { (result) in
            switch result {
            case .success(let response):
                var resourceDict = response["data"] as! [String : Any]
                resourceDict += tokenDict
                let dispatchModel = try! ["data" : resourceDict].mapModel(GameDispatchModel.self)
                completion(.success(dispatchModel))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
