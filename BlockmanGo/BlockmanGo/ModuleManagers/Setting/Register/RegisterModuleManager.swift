//
//  RegisterModuleManager.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/8/28.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation

struct RegisterModuleManager {
    static func regenerateAuthorization(completion: @escaping (BlockHTTPResult<Void, BlockHTTPError>) -> Void) {
        UserRequester.regenerateAuthToken(completion: { (result) in
            switch result {
            case .success(let response):
                let authModel = try! response.mapModel(AuthTokenModel.self)
                UserManager.shared.setAuthorization(authModel)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
