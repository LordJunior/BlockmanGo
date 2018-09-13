//
//  ThirdLoginSecurityModuleManager.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/9/5.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation

struct ThirdSignSecurityModuleManager {
    static func bindThirdLogin(openID: String, token: String, platform: SignInPlatformEnum, completion: @escaping (BlockHTTPResult<Void, BlockHTTPError>) -> Void) {
        UserRequester.bindThirdLogin(openID: openID, token: token, platform: platform) { (result) in
            switch result {
            case .success(_):
                UserManager.shared.didBindSign(platform: platform)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func unbindThirdLogin(completion: @escaping (BlockHTTPResult<Void, BlockHTTPError>) -> Void) {
        UserRequester.unbindThirdLogin { (result) in
            switch result {
            case .success(_):
                UserManager.shared.didBindSign(platform: .app)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
