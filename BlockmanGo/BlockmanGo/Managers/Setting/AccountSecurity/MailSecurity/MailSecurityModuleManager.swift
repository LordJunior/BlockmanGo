//
//  MailSecurityModuleManager.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/9/3.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation

struct MailSecurityModuleManager {
    
    func sendCaptcha(mailAddress: String, completion: @escaping (BlockHTTPResult<Void, BlockHTTPError>) -> Void) {
        UserRequester.sendBindEmailCaptcha(mailAddress: mailAddress) { (result) in
            switch result {
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func bindMail(_ mailAddress: String, captcha: String, completion: @escaping (BlockHTTPResult<Void, BlockHTTPError>) -> Void) {
        UserRequester.bindEmail(mailAddress: mailAddress, captcha: captcha) { (result) in
            switch result {
            case .success(_):
                UserManager.shared.didBindEmail(mailAddress)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func unbindMail(completion: @escaping (BlockHTTPResult<Void, BlockHTTPError>) -> Void) {
        UserRequester.unbindEmail(completion: { (result) in
            switch result {
            case .success(_):
                UserManager.shared.didBindEmail("")
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
