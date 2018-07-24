//
//  UserManager.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/11.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation

class UserManager {
    
    private var userModel: UserModel?
    
    static let shared = UserManager()
    
    private init() {
        
    }
    
    var userID: String {
        get {
            return userModel?.id ?? ""
        }
    }
    
    var nickname: String {
        get {
            return userModel?.nickName ?? ""
        }
    }

    var accessToken: String {
        get {
            return userModel?.accessToken ?? ""
        }
    }
    
    func setNickname(_ newValue: String) {
        userModel?.nickName = newValue
    }
    
    func setUserModel(_ model: UserModel) {
        userModel = model
    }
}
