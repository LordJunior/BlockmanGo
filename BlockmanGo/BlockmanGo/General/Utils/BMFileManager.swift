//
//  BMFileManager.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/18.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation

struct BMFileManager {

    private static let fileManager = FileManager.default
    
    static let cacheDirectory = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!)
    
    static let documentDirectory = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!)
    
    static func fileExists(atPath path: String) -> Bool {
        return fileManager.fileExists(atPath: path)
    }
    
    static func directoryExists(atPath path: String) -> Bool {
        var isDir: ObjCBool = false
        let isExists = fileManager.fileExists(atPath: path, isDirectory: &isDir)
        return isExists && isDir.boolValue
    }
    
    static func calculateFileSize(filePath: String) -> UInt64 {
        guard fileManager.fileExists(atPath: filePath) else {return 0}
        do {
            return try (fileManager.attributesOfItem(atPath: filePath)[.size] as? UInt64) ?? 0
        }catch {
            return 0
        }
    }
    
    static func calculateFolderSize(directoryPath: String) -> UInt64 {
        var isDirectory: ObjCBool = true
        guard fileManager.fileExists(atPath: directoryPath, isDirectory: &isDirectory), isDirectory.boolValue else {
            return 0
        }
        var totalSize: UInt64 = 0
        for subPath in fileManager.subpaths(atPath: directoryPath) ?? [] {
            let filePath = (directoryPath as NSString).appendingPathComponent(subPath)
            totalSize += calculateFileSize(filePath: filePath)
        }
        return totalSize
    }
    
    static func removeItem(atPath path: String) {
        do {
            try fileManager.removeItem(atPath: path)
        }catch {
            
        }
    }
}
