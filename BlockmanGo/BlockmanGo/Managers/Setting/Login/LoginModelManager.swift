//
//  LoginModelManager.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/8/28.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation

struct LoginModelManager {
    static func login(account: String, password: String, completion: @escaping (BlockHTTPResult<AuthTokenModel, BlockHTTPError>) -> Void) {
        UserRequester.login(account: account, password: password) { (result) in
            switch result {
            case .success(let response):
                let authModel = try! response.mapModel(AuthTokenModel.self)
                UserManager.shared.setAuthorization(authModel)
                completion(.success(authModel))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
