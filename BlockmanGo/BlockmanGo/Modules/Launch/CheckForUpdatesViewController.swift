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
            label.text = " Res: " + GameEngineInfo.resourceVersion
        }.layout { (make) in
            make.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(8)
        }
        
        progressView = ProgressView().addTo(superView: view).configure({ (progressView) in
            progressView.displayInfo = R.string.localizable.checking_engine_resource()
            progressView.progress = 0
        }).layout { (make) in
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalTo(appVersionLabel.snp.top).inset(-20)
            make.height.equalTo(41)
        }
        
//        checkForAppUpdates()
        checkForResourceUpdates()
    }
    
    private func checkForAppUpdates() {
        checkForUpdateManager.checkForAppUpdates { [unowned self] (result) in
            switch result {
            case .success(let appUpdateResult):
                guard appUpdateResult.updateIfNeed else {
                    self.checkForResourceUpdates()
                    return
                }
                AlertController.alert(title: R.string.localizable.find_new_version(), message: R.string.localizable.need_to_download_new_version(), from: TransitionManager.rootViewController, showCancelButton: !appUpdateResult.forceUpdateIfNeed)?.done(completion: { (_) in
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
            AlertController.alert(title:R.string.localizable.notification() , message: R.string.localizable.unpacking_resources_if_continue(), from: TransitionManager.rootViewController, showCancelButton: true)?.setCancelTitle("Exit").setDoneTitle("OK").done(completion: { (_) in
                self.engineResourceManager.copyBundleResourceToCache()
            }).cancel(completion: { (_) in
                abort()
            })
        }else if engineResourceManager.checkResourceUpdateIfNeed() {
            engineResourceManager.downloadResource()
        }else {
            progressView?.displayInfo = R.string.localizable.checking_done()
            self.progressView?.setProgress(1.0, animated: true)
            delay(0.5, exeute: {
                self.delegate?.checkForUpdatesDidFinished()
            })
        }
    }
}

extension CheckForUpdatesViewController: EngineResourceModelManagerDelegate {
    func engineResourceCopyInProgress(_ progress: Float, totalSize: UInt64) {
        DebugLog("engineResourceCopyInProgress \(progress)")
        progressView?.displayInfo = R.string.localizable.unpacking_resources(Double(totalSize) / 1024.0 / 1024.0)
        progressView?.setProgress(progress, animated: true)
    }
    
    func engineResourceCopyDidFinished() {
        DebugLog("engineResourceCopyDidFinished 初始化完成")
        progressView?.displayInfo = R.string.localizable.unpacking_finished()
        progressView?.setProgress(1.0, animated: true)
        delay(0.2) {
            self.delegate?.checkForUpdatesDidFinished()
        }
    }
}
