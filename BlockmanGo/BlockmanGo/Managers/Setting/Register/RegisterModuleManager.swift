//
//  RegisterModuleManager.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/8/28.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation

struct RegisterModuleManager {
    static func verifyPassword(_ password: String) -> Bool {
        return password ~= "^[a-zA-Z0-9]{6,12}$"
    }
}
