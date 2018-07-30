//
//  CheckForUpdatesModelManager.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/17.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation

class CheckForAppUpdatesModelManager {
    typealias AppUpdatesResult = (updateIfNeed: Bool, forceUpdateIfNeed: Bool, downloadURL: String)

    private var appVersionForItunes: String?
    
    func checkForAppUpdates(completion: @escaping (BlockHTTPResult<AppUpdatesResult, BlockHTTPError>) -> Void) {
            
        /// 先从iTunes获取对应的APP 版本信息
        Requester.requestWithTarget(ConfigurationAPI.fetchAppInfoFromiTunes) { [unowned self] (result) in
            switch result {
            case .success(let response):
                let results = response["results"] as! [[String : Any]]
                if !results.isEmpty {
                    self.appVersionForItunes = results.first!["version"] as? String
                }
                self.fetchAppUpdatesInfo(completion: completion)
            case .failure(_):
                self.appVersionForItunes = "2.0.0"
                self.fetchAppUpdatesInfo(completion: completion)
                break
            }
        }
    }
    
    /// 从服务器获取更新配置表
    private func fetchAppUpdatesInfo(completion: @escaping (BlockHTTPResult<AppUpdatesResult, BlockHTTPError>) -> Void) {
        guard let appVersionForItunes = appVersionForItunes else {
            completion(.success(AppUpdatesResult(false, false, ""))) /// 如果从iTunes请求不到数据，不弹更新
            return
        }
        guard AppInfo.currentShortVersion < appVersionForItunes else {
            completion(.success(AppUpdatesResult(false, false, ""))) /// 如果本地版本大于等于iTunes上的版本，不弹更新
            return
        }
        
        /// 请求后台更新配置表数据
        Requester.requestWithTarget(ConfigurationAPI.fetchAppUpdateInfo) { (result) in
            switch result {
            case .success(let response):
                let appUpdateModel = try! response.mapModel(CheckForAppUpdateModel.self)
                let currentLocalVersion = AppInfo.currentShortVersion
                guard appUpdateModel.version == appVersionForItunes else {
                    completion(.success(AppUpdatesResult(false, false, ""))) /// 如果配置表上的版本跟iTunes的最新版本不匹配，则不弹更新
                    return
                }
                /// 需要强更
                if appUpdateModel.isForceUpdate || currentLocalVersion < appUpdateModel.minAvailableVersion || appUpdateModel.needToForceUpdateVersions.contains(currentLocalVersion) {
                    completion(.success(AppUpdatesResult(true, true, appUpdateModel.downloadURL))) /// 强更
                    return
                }
                completion(.success(AppUpdatesResult(true, false, appUpdateModel.downloadURL))) /// 可选更新
            case .failure(_):
                completion(.success(AppUpdatesResult(false, false, ""))) /// 不弹更新
            }
        }
    }
}
