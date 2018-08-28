//
//  ProfileModel.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/8/24.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation
import HandyJSON
/*
"account": "string",
"birthday": "string",
"details": "string",
"diamonds": 0,
"email": "string",
"expireDate": "string",
"golds": 0,
"nickName": "string",
"picUrl": "string",
"sex": 0,
"telephone": "string",
"password": "string",
"userId": 0,
"vip": 0
*/
final class ProfileModel: HandyJSON {
    var nickname: String = ""
    var account: String = ""
    var birthday: String = ""
    var details: String = ""
    var email: String = ""
    var password: String = ""
    var portraitURL: String = ""
    var expireDate: String = ""
    var diamonds: UInt64 = 0
    var golds: UInt64 = 0
    var userID: UInt64 = 0
    var gender: Gender = .male
    var telephone: String = ""
    var vip: VIP = .vip
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.nickname <-- "nickName"
        
        mapper <<<
            self.userID <-- "userId"
        
        mapper <<<
            self.portraitURL <-- "picUrl"
        
        mapper <<<
            self.gender <-- TransformOf<Gender, Int>(fromJSON: { sex -> Gender in
                return Gender(rawValue: sex ?? 1) ?? .male
            }, toJSON: { gender -> Int in
                return gender?.rawValue ?? 1
            })
    }
}
