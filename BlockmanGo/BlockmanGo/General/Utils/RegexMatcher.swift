//
//  RegexMatcher.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/9/3.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation

extension String {
    static func ~= (text: String, regexString: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: regexString, options: []) else {return false}
        return regex.firstMatch(in: text, options: [], range: NSRange.init(text.startIndex..., in: text)) != nil
    }
}

struct RegexMatcher {
    static func match(text: String, regex: String) -> Bool {
        return text ~= regex
    }
}

extension RegexMatcher {
    static func match(nickname: String) -> Bool {
        let nicknameRegex = "^[a-zA-Z0-9_]{6,16}$"
        return match(text: nickname, regex: nicknameRegex)
    }
    
    static func match(password: String) -> Bool {
        let passwordRegex = "^[a-zA-Z0-9]{6,12}$"
        return match(text: password, regex: passwordRegex)
    }
    
    static func match(mail: String) -> Bool {
        let mailRegex = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        return match(text: mail, regex: mailRegex)
    }
    
    static func match(captcha: String, length: Int = 4) -> Bool {
        let captchaRegex = String.init(format: "^[0-9]{%d}$", length)
        return match(text: captcha, regex: captchaRegex)
    }
}
