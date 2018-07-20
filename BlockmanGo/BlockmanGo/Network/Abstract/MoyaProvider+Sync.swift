//
//  MoyaProvider+Sync.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/19.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation
import Moya

extension MoyaProvider {
    
    @discardableResult
    func synchronousRequest(_ target: Target) throws -> Moya.Response {
        let semaphore = DispatchSemaphore(value: 0)
        var response: Moya.Response?
        var error: Error? = nil
        request(target) { (result) in
            defer {semaphore.signal()}
            switch result {
            case .success(let res):
                response = res
            case .failure(let err):
                error = err
            }
        }
        semaphore.wait()
        
        guard error == nil else {
            throw error!
        }
        return response!
    }
}
