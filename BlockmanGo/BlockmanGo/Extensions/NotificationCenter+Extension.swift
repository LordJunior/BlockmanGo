//
//  Notification+Extension.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/8/29.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation

enum BMNotification: String {
    case refreshAccountInfo
    case registerSwitchToLogin
    case addNewFriend
    case deleteFriend
    case modifyAliasForFriend
    case refreshFriendList
    
    fileprivate var stringValue: String {
        return "BM" + rawValue
    }
    
    fileprivate var name: Notification.Name {
        return Notification.Name(rawValue: stringValue)
    }
}

extension NotificationCenter {
    static func post(notification: BMNotification, object: Any? = nil) {
        NotificationCenter.default.post(name: notification.name, object: object)
    }
    
    /// 使用这个API需要自己持有返回值，以便用于removeObserver: 来移除通知
    static func addObserver(notification: BMNotification, object: Any? = nil, using: @escaping (Notification) -> Void) -> NSObjectProtocol {
        let observer = NotificationCenter.default.addObserver(forName: notification.name, object: object, queue: OperationQueue.main) { (notifi) in
            using(notifi)
        }
        return observer
    }
    
    static func removeObserver(_ observer: NSObjectProtocol?) {
        guard let observer = observer else {return}
        NotificationCenter.default.removeObserver(observer)
    }
}
