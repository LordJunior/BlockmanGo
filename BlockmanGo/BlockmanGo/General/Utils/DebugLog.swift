//
//  DebugLog.swift
//  BlockyModes
//
//  Created by KiBen on 2018/1/4.
//  Copyright © 2018年 SandboxOL. All rights reserved.
//

import Foundation

func DebugLog(_ item: @autoclosure () -> Any) {
#if DEBUG
    print(item())
#endif
}
