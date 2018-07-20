//
//  GameDetailModelManager.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/19.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation

struct GameDetailModelManager {
    func fetchGameDetails(gameID: String, completion: @escaping (BlockHTTPResult<GameDetailModel, BlockHTTPError>) -> Void) {
        GamesRequester.fetchGameDetails(gameID: gameID) { (result) in
            switch result {
            case .success(let response):
                let detailModel = try! response.mapModel(GameDetailModel.self)
                completion(.success(detailModel))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func likesGame(gameID: String, completion: @escaping (BlockHTTPResult<Int, BlockHTTPError>) -> Void) {
        GamesRequester.fetchGameDetails(gameID: gameID) { (result) in
            switch result {
            case .success(let response):
                completion(.success(response["data"] as! Int))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
