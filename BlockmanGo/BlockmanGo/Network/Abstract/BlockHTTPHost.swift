//
//  BlockHTTPHost.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/11.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation

var enterGameHost = ""
let apiVersion = "v1"

#if BLOCKY_OVERSEA
#if DEBUG
let serverHost = "http://mods.sandboxol.com"/* "http://120.92.158.119"*/
    #else
let serverHost = "http://mods.sandboxol.com"
#endif
#else
#if DEBUG
let serverHost = "http://120.92.158.119"
    #else
let serverHost = "http://mods.sandboxol.com"
#endif
#endif
