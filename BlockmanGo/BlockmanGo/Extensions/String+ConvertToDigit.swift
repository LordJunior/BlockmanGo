//
//  String+Extension.swift
//  BlockyModes
//
//  Created by KiBen on 2018/6/12.
//  Copyright © 2018年 SandboxOL. All rights reserved.
//

import Foundation

extension String {
    func toInt() -> Int {
        return Int(self) ?? 0
    }
    
    func toInt32() -> Int32 {
        return Int32(self) ?? 0
    }
    
    func toInt64() -> Int64 {
        return Int64(self) ?? 0
    }
    
    func toUInt() -> UInt {
        return UInt(self) ?? 0
    }
    
    func toUInt32() -> UInt32 {
        return UInt32(self) ?? 0
    }
    
    func toUInt64() -> UInt64 {
        return UInt64(self) ?? 0
    }
}
