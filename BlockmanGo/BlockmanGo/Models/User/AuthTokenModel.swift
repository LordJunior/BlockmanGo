//
//  UserModel.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/11.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation
import HandyJSON

/*
 "accessToken": "string",
 "userId": 0
 */
final class AuthTokenModel: HandyJSON {
    var accessToken: String = ""
    var userId: UInt64 = 0
}
