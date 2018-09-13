//
//  ResourceManager.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/18.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation
import Moya

protocol EngineResourceModelManagerDelegate: class {
    func engineResourceCopyInProgress(_ progress: Float, totalSize: UInt64)
    func engineResourceCopyDidFinished()
    
//    func engineResourceWillDownload()
//    func engineResourceDownloadInPorgress(_ progress: Float)
//    func engineResourceDownloadDidFinished()
//    func engineResourceDownloadFailed(_ error: Error)
}

final class EngineResourceModelManager {
    
    weak var delegate: EngineResourceModelManagerDelegate?
    
    private let copyFileTool = CopyFileTool()
    
    init() {
        copyFileTool.delegate = self
    }
    
    /// 判断是否需要从本地拷贝资源到缓存目录
    /// 首次安装或者更新APP之后首次打开
    func copyResourceFromBundleIfNeed() -> Bool {
        guard let resourceVersionCache = BMUserDefaults.string(forKey: .engineResourceVersion) else {
            return true // 首次安装
        }
        return resourceVersionCache < GameEngineInfo.resourceVersion //比安装包里 预先打包好的资源版本小
    }
    
    /// 拷贝安装包里的资源到缓存目录
    func copyBundleResourceToCache() {
        BMFileManager.removeItem(atPath: BMFileManager.engineResourceCacheDirectory)
        copyFileTool.copyFiles(atDirectory: BMFileManager.engineResourceBundleDirectory, toDirectory: BMFileManager.engineResourceCacheDirectory)
    }
    
    /// 检查是否要更新资源文件
//    completion: @escaping (Bool) -> Void
    func checkResourceUpdateIfNeed() -> Bool {
        var updateIfNeed = false
        return updateIfNeed
        GamesRequester.fetchGamesWithMode(0) { (_) in
            updateIfNeed = true
        }
        let timeout = Date(timeIntervalSinceNow: 5)
        while !updateIfNeed && RunLoop.main.run(mode: .defaultRunLoopMode, before: timeout) {    
        }
        return updateIfNeed
    }
    
    func downloadResource() {
//        delegate?.engineResourceWillDownload()
    }
}

extension EngineResourceModelManager: CopyFileToolDelegate {
    func copyFileInProgress(_ progress: Float, totalSize: UInt64) {
        delegate?.engineResourceCopyInProgress(progress, totalSize: totalSize)
    }
    
    func copyFileDidFinished() {
        BMUserDefaults.setString(GameEngineInfo.resourceVersion, forKey: .engineResourceVersion)
        delegate?.engineResourceCopyDidFinished()
    }
}

