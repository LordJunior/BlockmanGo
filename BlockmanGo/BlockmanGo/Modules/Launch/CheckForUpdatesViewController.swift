//
//  CheckForUpdatesViewController.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/16.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit

protocol CheckForUpdatesViewControllerDelegate: class {
    func checkForUpdatesDidFinished()
}

class CheckForUpdatesViewController: UIViewController {

    weak var delegate: CheckForUpdatesViewControllerDelegate?
    
    private weak var progressView: ProgressView?
    private let checkForUpdateManager = CheckForAppUpdatesModelManager()
    private let engineResourceManager = EngineResourceModelManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        engineResourceManager.delegate = self
        
        view.layer.contents = R.image.check_update_background()?.cgImage
        view.layer.contentsScale = UIScreen.main.scale
        
        let appVersionLabel = UILabel().addTo(superView: view).configure { (label) in
            label.textColor = UIColor.white
            label.font = UIFont.size13
            label.text = "Version 1.3.20"
        }.layout { (make) in
            make.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(8)
        }
        
        progressView = ProgressView().addTo(superView: view).configure({ (progressView) in
            progressView.displayInfo = "正在检查资源..."
            progressView.progress = 0
            progressView.isHidden = true
        }).layout { (make) in
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalTo(appVersionLabel.snp.top).inset(-20)
            make.height.equalTo(41)
        }
        
        checkForAppUpdates()
    }
    
    private func checkForAppUpdates() {
        checkForUpdateManager.checkForAppUpdates { [unowned self] (result) in
            switch result {
            case .success(let appUpdateResult):
                guard appUpdateResult.updateIfNeed else {
                    self.checkForResourceUpdates()
                    return
                }
                AlertController.alert(title: "发现新版本", message: "需要下载更新客户端", from: TransitionManager.rootViewController, showCancelButton: !appUpdateResult.forceUpdateIfNeed)?.done(completion: { (_) in
                    openURL(appUpdateResult.downloadURL)
                }).cancel(completion: { (_) in
                    if appUpdateResult.forceUpdateIfNeed {
                        abort()
                    }else {
                        self.checkForResourceUpdates()
                    }
                })
            default:
                break
            }
        }
    }
    
    private func checkForResourceUpdates() {
        self.progressView?.isHidden = false
        if engineResourceManager.copyResourceFromBundleIfNeed() {
            engineResourceManager.copyBundleResourceToCache()
        }else if engineResourceManager.checkResourceUpdateIfNeed() {
            engineResourceManager.downloadResource()
        }else {
            delegate?.checkForUpdatesDidFinished()
        }
    }
}

extension CheckForUpdatesViewController: EngineResourceModelManagerDelegate {
    func engineResourceCopyInProgress(_ progress: Float) {
        print("engineResourceCopyInProgress \(progress)")
        progressView?.displayInfo = "正在初始化游戏资源..."
        progressView?.setProgress(progress, animated: true)
    }
    
    func engineResourceCopyDidFinished() {
        progressView?.displayInfo = "初始化完成"
        progressView?.setProgress(1.0, animated: true)
        delay(0.2) {
            self.delegate?.checkForUpdatesDidFinished()
        }
    }
}
