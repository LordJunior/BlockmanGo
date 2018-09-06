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
    
    static func regenerateAuthToken(completion: @escaping RequestJsonCallBack) {
        Requester.requestWithTarget(UserAPI.regenerateAuthToken(), completion: completion)
    }
    
    static func fetchUserProfile(completion: @escaping RequestJsonCallBack) {
        Requester.requestWithTarget(UserAPI.fetchUserProfile(), completion: completion)
    }

    static func initializeProfile(nickname: String, gender: Int, completion: @escaping RequestJsonCallBack) {
        Requester.requestWithTarget(UserAPI.initializeProfile(nickname: nickname, gender: gender), completion: completion)
    }
    
    static func login(account: String, password: String, channel: SignInPlatformEnum = .app, completion: @escaping RequestJsonCallBack) {
        Requester.requestWithTarget(UserAPI.login(account: account, passwd: password, platform: channel.rawValue), completion: completion)
    }
    
    static func setPassword(_ password: String, completion: @escaping RequestJsonCallBack) {
        Requester.requestWithTarget(UserAPI.setPassword(password), completion: completion)
    }
    
    static func modifyPassword(origin: String, new: String, completion: @escaping RequestJsonCallBack) {
        Requester.requestWithTarget(UserAPI.modifyPassword(origin: origin, new: new), completion: completion)
    }
    
    static func bindEmail(mailAddress: String, captcha: String, completion: @escaping RequestJsonCallBack) {
        Requester.requestWithTarget(UserAPI.bindEmail(mailAddress, captcha), completion: completion)
    }
    
    static func unbindEmail(completion: @escaping RequestJsonCallBack) {
        Requester.requestWithTarget(UserAPI.unbindEmail(), completion: completion)
    }
    
    static func sendBindEmailCaptcha(mailAddress: String, completion: @escaping RequestJsonCallBack) {
        Requester.requestWithTarget(UserAPI.sendBindEmailCaptcha(mailAddress), completion: completion)
    }

    static func bindThirdLogin(openID: String, token: String, platform: SignInPlatformEnum, completion: @escaping RequestJsonCallBack) {
        Requester.requestWithTarget(UserAPI.bindThirdLogin(openID, token, platform.rawValue), completion: completion)
    }
    
    static func unbindThirdLogin(completion: @escaping RequestJsonCallBack) {
        Requester.requestWithTarget(UserAPI.unbindThirdLogin(), completion: completion)
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
//
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
