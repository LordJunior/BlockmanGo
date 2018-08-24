//
//  LaunchManager.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/23.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation

struct LaunchModelManager {
    
    /// 首次安装应用会生成一个新的用户
    /// 其他情况会去检查本地用户token有效性
    func generateNewAuthorizationIfNeed() {
        UserRequester.authToken { (result) in
            switch result {
            case .success(let response):
                let authModel = try! response.mapModel(AuthTokenModel.self)
                UserManager.shared.setAuthorization(authModel)
            case .failure(.userNotBindDevice):
                TransitionManager.presentInHidePresentingTransition(LoginViewController.self, parameter: true)
            default:
                break
            }
        }
    }
}
