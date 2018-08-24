//
//  HomePageModelManager.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/8/24.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation

struct HomePageModelManager {
    func fetchUserProfile(completion: @escaping (BlockHTTPResult<ProfileModel, BlockHTTPError>) -> Void) {
        UserRequester.fetchUserProfile { (result) in
            switch result {
            case .success(let response):
                let profileModel = try! response.mapModel(ProfileModel.self)
                UserManager.shared.setProfile(profileModel)
                completion(.success(profileModel))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
