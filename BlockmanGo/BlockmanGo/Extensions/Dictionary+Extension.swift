//
//  Dictionary+Extension.swift
//  BlockyModes
//
//  Created by KiBen on 2017/12/22.
//  Copyright © 2017年 SandboxOL. All rights reserved.
//

import Foundation

extension Dictionary {
    
    static func += (left: inout Dictionary, right: Dictionary?) {
        guard let right = right else {
            return
        }
        
        for (key, value) in right {
            left.updateValue(value, forKey: key)
        }
    }
}
