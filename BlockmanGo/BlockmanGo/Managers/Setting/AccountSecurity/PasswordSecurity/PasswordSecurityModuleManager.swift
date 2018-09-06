//
//  PasswordSecurityModuleManager.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/8/29.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation

struct PasswordSecurityModuleManager {
    
    static func setPassword(_ password: String, completion: @escaping (BlockHTTPResult<Void, BlockHTTPError>) -> Void) {
        UserRequester.setPassword(password) { (result) in
            switch result {
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func modifyPassword(origin: String, new: String, completion: @escaping (BlockHTTPResult<Void, BlockHTTPError>) -> Void) {
        UserRequester.modifyPassword(origin: origin, new: new) { (result) in
            switch result {
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
