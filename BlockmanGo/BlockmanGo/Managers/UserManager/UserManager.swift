//
//  UserManager.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/11.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation

class UserManager {
    
    private var authModel: AuthTokenModel?
    private var profileModel: ProfileModel?
    
    static let shared = UserManager()
    
    private init() {
        initializeAuth()
        initializeProfile()
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillTerminateCallback), name: NSNotification.Name.UIApplicationWillTerminate, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var userID: UInt64 {
        get {
            return authModel?.userId ?? 0
        }
    }
    
    var nickname: String {
        get {
            return profileModel?.nickname ?? ""
        }
    }

    var gender: Gender {
        return profileModel?.gender ?? .male
    }
    
    var portraitURL: String {
        return profileModel?.portraitURL ?? ""
    }
    
    var loginPlatform: LoginPlatformEnum {
        return profileModel?.platform ?? .app
    }
    
    var accessToken: String {
        get {
            return authModel?.accessToken ?? ""
        }
    }

    static func authorizationExistsAtLocal() -> Bool {
        return BMUserDefaults.data(forKey: .authToken) != nil
    }
    
    /// 当前这个账号是否设置了密码
    func hasPassword() -> Bool {
        return profileModel?.hasPassword ?? false
    }
    
    func setNickname(_ newValue: String) {
        profileModel?.nickname = newValue
    }
    
    func setAuthorization(_ auth: AuthTokenModel) {
        authModel = auth
    }
    
    func setProfile(_ profile: ProfileModel) {
        profileModel = profile
    }
    
    func clear() {
        authModel = nil
        profileModel = nil
    }
    
    private func initializeAuth() {
        guard let authData = BMUserDefaults.data(forKey: .authToken) else { return }
        do {
            let authJson = try JSONSerialization.jsonObject(with: authData, options: .allowFragments) as? [String : Any]
            authModel = AuthTokenModel.deserialize(from: authJson)
        }catch {
        }
    }
    
    private func initializeProfile() {
        guard let profileData = BMUserDefaults.data(forKey: .userProfile) else { return }
        do {
            let profileJson = try JSONSerialization.jsonObject(with: profileData, options: .allowFragments) as? [String : Any]
            profileModel = ProfileModel.deserialize(from: profileJson)
        }catch {
        }
    }
    
    @objc private func applicationWillTerminateCallback() {
        persistAuth()
        persistProfile()
    }
    
    private func persistAuth() {
        guard let authJson = authModel?.toJSON() else {return}
        do {
            let authData = try JSONSerialization.data(withJSONObject: authJson, options: .prettyPrinted)
            BMUserDefaults.setData(authData, forKey: .authToken)
        }catch {
        }
    }
    
    private func persistProfile() {
        guard let profileJson = profileModel?.toJSON() else {return}
        do {
            let profileData = try JSONSerialization.data(withJSONObject: profileJson, options: .prettyPrinted)
            BMUserDefaults.setData(profileData, forKey: .userProfile)
        }catch {
        }
    }
}
