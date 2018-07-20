//
//  UserManager.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/11.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation

struct UserManager {
    func aa() {

        Requester.requestWithTarget(User.fetchDailyTasks()) { (result) in
            switch result {
            case .success(let reponse):
                let model = try! reponse.mapModel(UserModel.self)
            default:
                break
            }
        }
    }
}
