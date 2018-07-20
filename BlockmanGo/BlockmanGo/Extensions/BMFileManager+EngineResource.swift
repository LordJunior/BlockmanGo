//
//  BMFileManager+EngineResource.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/18.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation

extension BMFileManager {
    private static let resourceFolderName = "EngineResource"
    
    static let engineResourceCacheDirectory = BMFileManager.cacheDirectory.appendingPathComponent(resourceFolderName).path
    
    static let engineResourceBundleDirectory = Bundle.main.resourceURL!.appendingPathComponent(resourceFolderName).path
}
