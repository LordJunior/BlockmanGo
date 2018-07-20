//
//  GamesAPI.swift
//  BlockyModes
//
//  Created by KiBen Hung on 2017/11/2.
//  Copyright © 2017年 SandboxOL. All rights reserved.
//

import Foundation
import Moya

let gamePathPrefix = "/game"

enum GamesAPI {
    case gamesList(Int) // 游戏列表
    case gameDetailInfo(String) // 游戏详情信息
    case appreciate(String) // 点赞
    
    case recommendationList // 推荐
    case recentlyPlayingList // 最近在玩
    case friendsPlayingList // 好友在玩
    
    
    case fetchEnterGameToken(String)
    case enterGame(String, Int)
    case createGameChatRoom(String)
    case dissolveGameChatRoom(String)
}

extension GamesAPI: TargetType {
    var baseURL: URL {
        switch self {
        case .enterGame(_, _):
            return URL.init(string: enterGameHost)!
        default:
            return URL.init(string: serverHost)!
        }
    }
    
    var path: String {
        switch self {
        case .gamesList(_):
            return "\(gamePathPrefix)/api/\(apiVersion)/games"
        case let .gameDetailInfo(gameId):
            return "\(gamePathPrefix)/api/\(apiVersion)/games/\(gameId)"
        case let .appreciate(gameId):
            return "\(gamePathPrefix)/api/\(apiVersion)/games/\(gameId)/appreciation"
            
        case .recommendationList:
            return "\(gamePathPrefix)/api/\(apiVersion)/games/recommendation/all"
        case .recentlyPlayingList:
            return "\(gamePathPrefix)/api/\(apiVersion)/games/playlist/recently"
        case .friendsPlayingList:
            return "\(gamePathPrefix)/api/\(apiVersion)/games/playlist/friends"
        case .fetchEnterGameToken(_):
            return "\(gamePathPrefix)/api/\(apiVersion)/game/auth"
        case .createGameChatRoom(_):
            return "\(gamePathPrefix)/api/\(apiVersion)/game/chat/room"
        case .dissolveGameChatRoom(_):
            return "\(gamePathPrefix)/api/\(apiVersion)/game/chat/room"
        case .enterGame(_, _):
            return "/v1/dispatch"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .appreciate:
            return .put
        case .enterGame(_), .createGameChatRoom(_):
            return .post
        case .dissolveGameChatRoom(_):
            return .delete
        default:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .gamesList(mode):
            return .requestParameters(parameters: ["typeId" : mode, "pageNo" : 0, "pageSize" : 100, "isPublish" : 1, "os" : "ios", "appVersion" : 10000], encoding: URLEncoding.queryString)
            
        case let .fetchEnterGameToken(gameType):
            return .requestParameters(parameters: ["typeId" : gameType, "gameVersion" : GameEngineInfo.engineVersion], encoding: URLEncoding.queryString)
        case .enterGame(_, let region):
//            return .requestParameters(parameters: ["clz" : 0, "rid" : region, "name" : AccountInfoManager.shared.nickname.value, "pioneer" : true, "ever" : GameEngineInfo.version], encoding: JSONEncoding.default)
            return .requestParameters(parameters: ["clz" : 0, "rid" : region, "name" : "", "pioneer" : true, "ever" : GameEngineInfo.engineVersion], encoding: JSONEncoding.default)
        case .recommendationList:
            return .requestParameters(parameters: ["os" : "ios"], encoding: URLEncoding.queryString)
        case let .createGameChatRoom(roomName):
            return .requestParameters(parameters: ["roomName" : roomName], encoding: URLEncoding.queryString)
        case let .dissolveGameChatRoom(roomID):
            return .requestParameters(parameters: ["roomId" : roomID], encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var headers: [String : String]? {
        var header: [String : String] = [:]
        switch self{
        case let .enterGame(token, _):
//            header["x-shahe-uid"] = AccountInfoManager.shared.userId.value
            header["x-shahe-token"] = token
        default:
//            header["userId"] = AccountInfoManager.shared.userId.value
//            header["Access-Token"] = AccountInfoManager.shared.token.value
            header["language"] = Locale.current.identifier
        }
        return header
    }
}
