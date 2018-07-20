//
//  OpenURL.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/17.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation

func openURL(_ urlString: String) {
    guard let url = URL.init(string: urlString) else {return}
    guard UIApplication.shared.canOpenURL(url) else {return}
    UIApplication.shared.openURL(url)
}
