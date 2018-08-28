//
//  String+Regex.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/8/27.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation

extension String {
    static func ~= (text: String, regexString: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: regexString, options: []) else {return false}
        return regex.firstMatch(in: text, options: [], range: NSRange.init(text.startIndex..., in: text)) != nil
    }
}
