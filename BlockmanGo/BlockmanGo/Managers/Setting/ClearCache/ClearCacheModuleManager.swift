//
//  SettingModuleManager.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/9/6.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation
import Kingfisher

struct ClearCacheModuleManager {
    private static var mapCachePath: String {
        var cachePath = BMFileManager.engineResourceCacheDirectory
        cachePath.append("/map")
        return cachePath
    }
    
    private static func cacheSizeText(_ size: UInt) -> String {
        return String(format: "%.1f M", Float(size) / 1024.0 / 1024.0)
    }
    
    private static func cacheSizeText(_ size: UInt64) -> String {
        return  String(format: "%.1f M", Double(size) / 1024.0 / 1024.0)
    }
    
    static func calculateImageCacheSize(completion handler: @escaping ((_ size: String) -> Void)) {
        ImageCache.default.calculateDiskCacheSize { size in
            handler(cacheSizeText(size))
        }
    }
    
    static func calculateMapCacheSize(completion handler: @escaping ((_ size: String) -> Void)) {
        DispatchQueue.global().async {
            let totalSize = BMFileManager.calculateFolderSize(directoryPath: ClearCacheModuleManager.mapCachePath)
            DispatchQueue.main.async {
                handler(cacheSizeText(totalSize))
            }
        }
    }
    
    static func clearImageCache(completion handler: (()->())? = nil) {
        ImageCache.default.clearDiskCache {
            handler?()
        }
    }
    
    static func clearMapCache(completion handler: (()->())? = nil) {
        DispatchQueue.global().async {
            do {
                try FileManager.default.removeItem(atPath: ClearCacheModuleManager.mapCachePath)
            }catch { }
            DispatchQueue.main.async {
                handler?()
            }
        }
    }
}
