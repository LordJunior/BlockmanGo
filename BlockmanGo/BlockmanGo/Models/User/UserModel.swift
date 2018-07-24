//
//  UserModel.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/11.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation
import HandyJSON

final class UserModel: HandyJSON {
    var accessToken: String = ""
    var id: String = ""
    var nickName: String = ""
}
