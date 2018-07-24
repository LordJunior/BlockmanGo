//
//  LaunchManager.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/23.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation

struct LaunchModelManager {
    func generateNewAccount() {
        UserRequester.fetchVisitorInfo { (result) in
            switch result {
            case .success(let response):
                let visitorModel = try! response.mapModel(UserModel.self)
                UserManager.shared.setUserModel(visitorModel)
            case .failure(_):
                break
            }
        }
    }
}
