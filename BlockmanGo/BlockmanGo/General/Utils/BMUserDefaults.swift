//
//  BlockyUserDefaults.swift
//  BlockyModes
//
//  Created by KiBen on 2017/12/28.
//  Copyright © 2017年 SandboxOL. All rights reserved.
//

import Foundation

extension BMUserDefaults {
    enum Key: String {
        case engineResourceVersion
        case appShortVersion
        case authToken
        case userProfile
    }
}

struct BMUserDefaults {
    static private let userDefaults = UserDefaults.standard
    
    public static func setString(_ string: String?, forKey key: BMUserDefaults.Key) {
        userDefaults.set(string, forKey: key.rawValue)
        userDefaults.synchronize()
    }
    
    public static func string(forKey key: BMUserDefaults.Key) -> String? {
        return userDefaults.string(forKey: key.rawValue)
    }
    
    public static func setData(_ data: Data?, forKey key: BMUserDefaults.Key) {
        userDefaults.set(data, forKey: key.rawValue)
        userDefaults.synchronize()
    }
    
    public static func data(forKey key: BMUserDefaults.Key) -> Data? {
        return userDefaults.data(forKey: key.rawValue)
    }
    
    public static func setTimeInterval(_ timeInterval: TimeInterval, forKey key: BMUserDefaults.Key) {
        userDefaults.set(timeInterval, forKey: key.rawValue)
        userDefaults.synchronize()
    }
    
    public static func timeInterval(forKey key: BMUserDefaults.Key) -> TimeInterval {
        return userDefaults.double(forKey: key.rawValue)
    }
    
    public static func setDate(_ date: Date?, forKey key: BMUserDefaults.Key) {
        userDefaults.set(date, forKey: key.rawValue)
        userDefaults.synchronize()
    }
    
    public static func date(forKey key: BMUserDefaults.Key) -> Date? {
        return userDefaults.object(forKey: key.rawValue) as? Date
    }
    
    public static func setInteger(_ integer: Int, forKey key: BMUserDefaults.Key) {
        userDefaults.set(integer, forKey: key.rawValue)
        userDefaults.synchronize()
    }
    
    public static func integer(forKey key: BMUserDefaults.Key) -> Int {
        return userDefaults.integer(forKey: key.rawValue)
    }
    
    public static func setBool(_ bool: Bool, forKey key: BMUserDefaults.Key) {
        userDefaults.set(bool, forKey: key.rawValue)
        userDefaults.synchronize()
    }
    
    public static func bool(forKey key: BMUserDefaults.Key) -> Bool {
        return userDefaults.bool(forKey: key.rawValue)
    }
    
    public static func removeValue(forKey key: BMUserDefaults.Key) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
}
