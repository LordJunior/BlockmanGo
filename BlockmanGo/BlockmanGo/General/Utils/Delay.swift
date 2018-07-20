//
//  Delay.swift
//  BlockyModes
//
//  Created by KiBen on 2018/4/25.
//  Copyright © 2018年 SandboxOL. All rights reserved.
//

import Foundation

func delay(_ delay: TimeInterval, exeute: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
        exeute()
    }
}
