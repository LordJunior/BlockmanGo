//
//  UserAPI.swift
//  BlockyModes
//
//  Created by KiBen on 2017/10/17.
//  Copyright © 2017年 SandboxOL. All rights reserved.
//

import Foundation
import Moya

enum VerificationCodeType: String {
    case phoneBind
    case unbindPhone
    case passwordReFound
}

enum Channel: String {
    case app
    case facebook
    case twitter
}

let userPathPrefix = "/user"

enum User {
    case fetchVisitor()
    case register(account: String, passwd: String)
    case registerInfo(nickname: String, gender: Int, picUrl: String, uid: String, token: String)
    case login(account: String, passwd: String, channel: Channel)
    case modifyNickname(String)
    case modifyPassword(origin: String, new: String)
    case resetPassword(String, phone: String, verificationCode: String)
    case modifyIntroduction(String)
    case modifyGender(Int)
    case modifyBirthday(String)
    case modifyPortrait(String)
    case fetchVerificationCode(phone: String, type: VerificationCodeType)
    case bindPhone(String, verificationCode: String)
    case unbindPhone(String, verificationCode: String)
    case uploadImage(filePath: String, fileName: String, uid: String, token: String)
    case fetchBindEmailVerifyCode(String)
    case bindEmail(String, String)
    case unbindEmail()
    case sendResetPasswordEmail(String)
    case fetchDailyTasks()
    case signInDailyTask(Int)
    case fetchRongToken()
}

extension User : TargetType {
    typealias ResultType = UserModel
    
    var baseURL: URL {
        switch self {
        case let .uploadImage(filePath: _, fileName: fileName, uid: _, token: _):
            return URL.init(string: serverHost + "\(userPathPrefix)/api/\(apiVersion)/file?fileName=" + fileName)!
            
        default:
            return URL.init(string: serverHost)!
        }
    }
    
    var path: String {
        switch self {
        case .fetchVisitor():
            return "\(userPathPrefix)/api/\(apiVersion)/visitor"
            
        case .register(_, _):
            return "\(userPathPrefix)/api/\(apiVersion)/register"
            
        case .registerInfo(nickname: _, gender: _, picUrl: _, uid: _, token: _):
            return "\(userPathPrefix)/api/\(apiVersion)\(userPathPrefix)/register"
            
        case .login(account: _, passwd: _, channel: _):
            return "\(userPathPrefix)/api/\(apiVersion)/login"

        case .modifyIntroduction(_), .modifyPortrait(_), .modifyNickname(_), .modifyGender(_), .modifyBirthday(_):
            return "\(userPathPrefix)/api/\(apiVersion)\(userPathPrefix)/info"
            
        case .modifyPassword(origin: _, new: _):
            return "\(userPathPrefix)/api/\(apiVersion)\(userPathPrefix)/password/modify"
            
        case .resetPassword(_, phone: _, verificationCode: _):
            return "\(userPathPrefix)/api/\(apiVersion)\(userPathPrefix)/password"
            
        case .bindPhone(_, verificationCode: _):
            return "\(userPathPrefix)/api/\(apiVersion)\(userPathPrefix)/bind/phone"
            
        case .unbindPhone(_, verificationCode: _):
            return "\(userPathPrefix)/api/\(apiVersion)\(userPathPrefix)/bind/phone"
            
        case let .fetchVerificationCode(phone: phone, type: type):
            switch type {
            case .passwordReFound:
                return "\(userPathPrefix)/api/\(apiVersion)/sms/send/refound"
            case .phoneBind, .unbindPhone:
                return "\(userPathPrefix)/api/\(apiVersion)/sms/send/\(phone)"
            }
            
        case .uploadImage(filePath: _, fileName: _, uid: _, token: _):
            return ""
            
        case .fetchBindEmailVerifyCode(_):
            return "\(userPathPrefix)/api/\(apiVersion)/emails/{email}"
            
        case .bindEmail(_, _):
            return "\(userPathPrefix)/api/\(apiVersion)/users/bind/email"
            
        case .unbindEmail():
//            return "\(userPathPrefix)//api/\(apiVersion)/users/\(AccountInfoManager.shared.userId.value)/emails"
            return "\(userPathPrefix)//api/\(apiVersion)/users/emails"
            
        case .sendResetPasswordEmail(_):
            return "\(userPathPrefix)/api/\(apiVersion)/emails/password/reset"
            
        case .fetchDailyTasks():
            return "\(userPathPrefix)/api/\(apiVersion)/users/new/daily/tasks"
            
        case let .signInDailyTask(type):
            return "\(userPathPrefix)/api/\(apiVersion)/users/new/daily/tasks/\(type)"
            
        case .fetchRongToken():
            return "\(userPathPrefix)/api/\(apiVersion)/users/device/token"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .modifyNickname(_), .modifyIntroduction(_), .modifyGender(_), .modifyBirthday(_), .modifyPortrait(_), .signInDailyTask(_):
            return .put
        case .unbindEmail():
            return .delete
        case .fetchDailyTasks(), .fetchRongToken():
            return .get
        default:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .fetchVisitor():
            return .requestParameters(parameters: ["os" : DeviceInfo.system, "appType" : "ios", "uuid" : DeviceInfo.uuid, "deviceId" : DeviceInfo.modelName], encoding: JSONEncoding.default)
            
        case let .register(account: uid, passwd: pwd):
            return .requestParameters(parameters: ["uid" : uid, "password" : pwd, "appType" : "ios", "deviceId" : DeviceInfo.modelName, "os" : DeviceInfo.system, "uuid" : DeviceInfo.uuid], encoding: JSONEncoding.default)
            
        case let .registerInfo(nickname: name, gender: gender, picUrl: picUrl, uid: _, token: _):
            return .requestParameters(parameters: ["nickName" : name, "sex" : gender, "picUrl" : picUrl], encoding: JSONEncoding.default)
            
        case let .login(account: uid, passwd: pwd, channel: channel):
            return .requestParameters(parameters: ["uid" : uid, "password" : pwd, "platform" : channel.rawValue, "appType" : "ios"], encoding: JSONEncoding.default)
            
        case let .modifyNickname(newNickname):
            return .requestParameters(parameters: ["nickName" : newNickname], encoding: JSONEncoding.default)
            
        case let .modifyIntroduction(introduction):
            return .requestParameters(parameters: ["details" : introduction], encoding: JSONEncoding.default)
            
        case let .modifyGender(gender):
            return .requestParameters(parameters: ["sex" : gender], encoding: JSONEncoding.default)
            
        case let .modifyBirthday(birthday):
            return .requestParameters(parameters: ["birthday" : birthday], encoding: JSONEncoding.default)

        case let .modifyPortrait(portrait):
            return .requestParameters(parameters: ["picUrl" : portrait], encoding: JSONEncoding.default)
            
        case let .modifyPassword(origin: origin, new: new):
            return .requestParameters(parameters: ["oldPassword" : origin, "newPassword" : new], encoding: JSONEncoding.default)
            
        case let .resetPassword(pwd, phone: phone, verificationCode: code):
            return .requestParameters(parameters: ["password" : pwd, "phone" : phone, "verifyCode" : code], encoding: JSONEncoding.default)
            
        case let .bindPhone(phone, verificationCode: code):
            return .requestParameters(parameters: ["verifyCode" : code, "phone" : phone], encoding: JSONEncoding.default)
            
        case let .unbindPhone(phone, verificationCode: code):
            return .requestParameters(parameters: ["verifyCode" : code, "phone" : phone], encoding: JSONEncoding.default)
            
        case let .fetchVerificationCode(phone: phone, type: type):
            switch type {
            case .passwordReFound:
                return .requestParameters(parameters: ["phone" : phone, "type" : type.rawValue], encoding: URLEncoding.queryString)
            case .phoneBind, .unbindPhone:
                return .requestParameters(parameters: ["type" : type.rawValue], encoding: URLEncoding.queryString)
            }
            
        case let .uploadImage(filePath: filePath, fileName: fileName, uid: _, token: _):
            let formData = MultipartFormData(provider: .file(URL.init(fileURLWithPath: filePath)), name: "file", fileName: fileName, mimeType: "image/jpeg")
            return .uploadMultipart([formData])
            
        case let .fetchBindEmailVerifyCode(email):
            return .requestParameters(parameters: ["email" : email], encoding: URLEncoding.queryString)
            
        case let .bindEmail(email, verifyCode):
            return .requestParameters(parameters: ["email" : email, "verifyCode" : verifyCode], encoding: JSONEncoding.default)
            
        case .unbindEmail():
            return .requestPlain
            
        case let .sendResetPasswordEmail(email):
            return .requestParameters(parameters: ["email" : email], encoding: URLEncoding.queryString)
            
        case .fetchDailyTasks(), .signInDailyTask(_):
            return .requestPlain
            
        case .fetchRongToken():
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var headers: [String : String]? {
        switch self {
        case .fetchVisitor():
            fallthrough
        case .register(account: _, passwd: _):
            fallthrough
        case .login(account: _, passwd: _, channel: _):
            fallthrough
        case .resetPassword(_, phone: _, verificationCode: _):
            fallthrough
        case .sendResetPasswordEmail(_):
            return nil
            
        case let .uploadImage(filePath: _, fileName: _, uid: uid, token: token), let .registerInfo(nickname: _, gender: _, picUrl: _, uid: uid, token: token):
            var header: [String : String] = [:]
            header["userId"] = uid
            header["Access-Token"] = token
            return header
            
        case .modifyNickname(_):
            fallthrough
        case .modifyIntroduction(_):
            fallthrough
        case .modifyGender(_):
            fallthrough
        case .modifyBirthday(_):
            fallthrough
        case .modifyPortrait(_):
            fallthrough
        case .modifyPassword(origin: _, new: _):
            fallthrough
        case .bindPhone(_, verificationCode: _):
            fallthrough
        case .unbindPhone(_, verificationCode: _):
            fallthrough
        case .fetchBindEmailVerifyCode(_):
            fallthrough
        case .bindEmail(_, _):
            fallthrough
        case .unbindEmail():
            fallthrough
        case .fetchDailyTasks():
            fallthrough
        case .signInDailyTask(_):
            fallthrough
        case .fetchRongToken():
            fallthrough
        case .fetchVerificationCode(phone: _, type: _):
            var header: [String : String] = [:]
//            header["userId"] = AccountInfoManager.shared.userId.value
//            header["Access-Token"] = AccountInfoManager.shared.token.value
            return header
        }
    }
}
