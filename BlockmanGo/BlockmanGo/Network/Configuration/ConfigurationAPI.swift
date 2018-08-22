//
//  ConfigurationAPI.swift
//  BlockyModes
//
//  Created by KiBen on 2017/12/28.
//  Copyright © 2017年 SandboxOL. All rights reserved.
//

import Foundation
import Moya

enum ConfigurationAPI {
    case fetchAppInfoFromiTunes
    case fetchAppUpdateInfo
    case fetchBulletin
}

extension ConfigurationAPI: TargetType {
    
    var baseURL: URL {
        switch self {
        case .fetchAppInfoFromiTunes:
            return URL.init(string: "http://itunes.apple.com")!
        case .fetchAppUpdateInfo, .fetchBulletin:
            return URL.init(string: "http://ols.sandboxol.com")!
        }
    }
    
    var path: String {
        switch self {
        case .fetchAppInfoFromiTunes:
            return "/lookup"
        case .fetchBulletin:
            return "/api/v1/config/ios-blockmango-bulletin"
        case .fetchAppUpdateInfo:
            return "/api/v1/config/ios-blockmango-new-version-config"
        }
    }
    
    var task: Task {
        switch self {
        case .fetchAppInfoFromiTunes:
            return .requestParameters(parameters: ["id" : 1426189000], encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var headers: [String : String]? {
        return nil
    }
}
