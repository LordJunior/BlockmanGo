//
//  BulletinModelManager.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/18.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation

struct BulletinModuleManager {
    static func fetchBulletin(completion: @escaping (NSAttributedString?) -> Void) {
        ConfigurationRequester.fetchBulletin { (result) in
            switch result {
            case .success(let response):
                let multiLanguageBulletin = response["data"] as! [String : String]
                let localBulletin = multiLanguageBulletin[Locale.current.identifier] ?? multiLanguageBulletin["en_US"]!
                let paraStyle = NSMutableParagraphStyle()
                paraStyle.alignment = .left
                paraStyle.lineSpacing = 10
                let attributes: [NSAttributedStringKey : Any] = [NSAttributedStringKey.foregroundColor : R.clr.appColor._a36b2e(), NSAttributedStringKey.font : UIFont.size12, NSAttributedStringKey.paragraphStyle : paraStyle]
                completion(NSAttributedString(string: localBulletin, attributes: attributes))
            default:
                completion(nil)
            }
        }
    }
}
