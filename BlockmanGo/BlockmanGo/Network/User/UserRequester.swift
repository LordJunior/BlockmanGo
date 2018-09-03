//
//  UserNetService.swift
//  BlockyModes
//
//  Created by KiBen on 2017/10/21.
//  Copyright © 2017年 SandboxOL. All rights reserved.
//

import Foundation
import Moya

struct UserRequester {
    
    static func authToken(completion: @escaping RequestJsonCallBack) {
        Requester.requestWithTarget(UserAPI.authToken(), completion: completion)
    }
    
    static func fetchUserProfile(completion: @escaping RequestJsonCallBack) {
        Requester.requestWithTarget(UserAPI.fetchUserProfile(), completion: completion)
    }

    static func initializeProfile(nickname: String, gender: Int, completion: @escaping RequestJsonCallBack) {
        Requester.requestWithTarget(UserAPI.initializeProfile(nickname: nickname, gender: gender), completion: completion)
    }
    
    static func login(account: String, password: String, channel: Channel = .app, completion: @escaping RequestJsonCallBack) {
        Requester.requestWithTarget(UserAPI.login(account: account, passwd: password, channel: channel), completion: completion)
    }
    
    static func setPassword(_ password: String, completion: @escaping RequestJsonCallBack) {
        Requester.requestWithTarget(UserAPI.setPassword(password), completion: completion)
    }
    
    static func modifyPassword(origin: String, new: String, completion: @escaping RequestJsonCallBack) {
        Requester.requestWithTarget(UserAPI.modifyPassword(origin: origin, new: new), completion: completion)
    }
    
//    class func registerInfo(nickname: String, picUrl: String, gender: Int, uid: String, token: String) -> Single<[String : Any]> {
//        return NetServer.requestWithTarget(User.registerInfo(nickname: nickname, gender: gender, picUrl: picUrl, uid: uid, token: token))
//    }
//    
    
    
    
//
//    class func modifyIntroduction(_ introduction: String) -> Single<[String : Any]> {
//        return NetServer.requestWithTarget(User.modifyIntroduction(introduction))
//    }
//    
//    class func modifyGender(_ gender: Int) -> Single<[String : Any]> {
//        return NetServer.requestWithTarget(User.modifyGender(gender))
//    }
//    
//    class func modifyBirthday(_ birthday: String) -> Single<[String : Any]> {
//        return NetServer.requestWithTarget(User.modifyBirthday(birthday))
//    }
//    
//    class func modifyPortrait(_ portrait: String) -> Single<[String : Any]> {
//        return NetServer.requestWithTarget(User.modifyPortrait(portrait))
//    }
//    
    
//
//    class func resetPassword(pwd: String, phone: String, verificationCode code: String) -> Single<[String : Any]> {
//        return NetServer.requestWithTarget(User.resetPassword(pwd, phone: phone, verificationCode: code))
//    }
//    
//    class func bindPhone(_ phone: String, verificationCode code: String) -> Single<[String : Any]> {
//        return NetServer.requestWithTarget(User.bindPhone(phone, verificationCode: code))
//    }
//    
//    class func unbindPhone(_ phone: String, verificationCode code: String) -> Single<[String : Any]> {
//        return NetServer.requestWithTarget(User.unbindPhone(phone, verificationCode: code))
//    }
//    
//    class func fetchVerificationCode(phone: String, type: VerificationCodeType) -> Single<[String : Any]> {
//        return NetServer.requestWithTarget(User.fetchVerificationCode(phone: phone, type: type), showToast: false)
//    }
//    
//    class func uploadImage(filePath: String, fileName: String, uid: String, token: String) -> Single<[String : Any]> {
//        return NetServer.requestWithTarget(User.uploadImage(filePath: filePath, fileName: fileName, uid: uid, token: token))
//    }
//    
//    class func fetchBindEmailVerifyCode(email: String) -> Single<[String : Any]> {
//        return NetServer.requestWithTarget(User.fetchBindEmailVerifyCode(email), showToast: true)
//    }
//    
//    class func bindEmail(email: String, verifyCode: String) -> Single<[String : Any]> {
//        return NetServer.requestWithTarget(User.bindEmail(email, verifyCode), showToast: true)
//    }
//    
//    class func unbindEmail() -> Single<[String : Any]> {
//        return NetServer.requestWithTarget(User.unbindEmail(), showToast: true)
//    }
//    
//    class func sendResetPasswordEmail(email: String) -> Single<[String : Any]> {
//        return NetServer.requestWithTarget(User.sendResetPasswordEmail(email), showToast: true)
//    }
//    
//    class func fetchDailyTasks() -> Single<[String : Any]> {
//        return NetServer.requestWithTarget(User.fetchDailyTasks(), showToast: false)
//    }
//    
//    class func signInDailyTask(type: Int) -> Single<[String : Any]> {
//        return NetServer.requestWithTarget(User.signInDailyTask(type), showToast: true)
//    }
//    
//    class func fetchRongToken() -> Single<[String : Any]> {
//        return NetServer.requestWithTarget(User.fetchRongToken(), showToast: false).retry(3)
//    }
}
