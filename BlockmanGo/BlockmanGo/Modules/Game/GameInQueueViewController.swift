//
//  GameInQueueViewController.swift
//  BlockyModes
//
//  Created by KiBen on 2018/6/15.
//  Copyright © 2018年 SandboxOL. All rights reserved.
//

import UIKit

protocol GameInQueueViewControllerDelegate: class {
    func gameInQueueViewControllerIntervalDidArrived(_ controller: GameInQueueViewController)
    func gameInQueueViewControllerCancelButtonDidClicked(_ controller: GameInQueueViewController)
}

extension GameInQueueViewControllerDelegate {
    func gameInQueueViewControllerIntervalDidArrived(_ controller: GameInQueueViewController) {}
    func gameInQueueViewControllerCancelButtonDidClicked(_ controller: GameInQueueViewController) {}
}

class GameInQueueViewController: UIViewController {

    /// 触发代理的时间间隔
    /// 默认为5秒
    var triggerInterval: Int = 10
    
    weak var delegate: GameInQueueViewControllerDelegate?
    
    private weak var inQueueTimeLabel: UILabel?
    private weak var timer: Timer?
    private var time = 0
    
    deinit {
        DebugLog("GameInQueueViewController Deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let inQueueDelegate = parameter as? GameInQueueViewControllerDelegate {
            delegate = inQueueDelegate
        }
        view.backgroundColor = UIColor.black.withAlphaComponent(0.45)
        
        let containView = UIImageView(image: R.image.general_alert_background()).addTo(superView: view).layout { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.45)
            make.height.equalToSuperview().multipliedBy(0.6)
        }.configure { (containView) in
            containView.isUserInteractionEnabled = true
        }
        
        let contentContainView = UIView().addTo(superView: containView).configure { (containView) in
            containView.backgroundColor = R.clr.appColor._eed5a0()
            containView.layer.cornerRadius = 12
            containView.clipsToBounds = true
        }.layout { (make) in
            make.right.top.left.equalToSuperview().inset(20)
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        
        inQueueTimeLabel = UILabel().addTo(superView: contentContainView).configure({ (label) in
            label.textColor = R.clr.appColor._844501()
            label.font = UIFont.boldSize15
            label.numberOfLines = 0
            label.text = "正在等待服务器分配资源\n00:00"
            label.textAlignment = .center
        }).layout(snapKitMaker: { (make) in
            make.top.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(10)
        })

        UIButton().addTo(superView: containView).configure { (button) in
            button.setBackgroundImage(R.image.general_button_background_selected(), for: .normal)
            button.titleLabel?.font = UIFont.size14
            button.setTitleColor(R.clr.appColor._b17f63(), for: .normal)
            button.setTitle(R.string.localizable.common_cancel(), for: .normal)
            button.addTarget(self, action: #selector(terminateButtonClick), for: .touchUpInside)
        }.layout { (make) in
            make.top.equalTo(contentContainView.snp.bottom).offset(10)
            make.height.equalTo(42)
            make.width.equalTo(contentContainView).multipliedBy(0.48)
            make.centerX.equalToSuperview()
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ternimateTimer()
    }
    
    @objc private func terminateButtonClick() {
        ternimateTimer()
        delegate?.gameInQueueViewControllerCancelButtonDidClicked(self)
    }
    
    private func ternimateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func timerCallback() {
        time += 1
        let minutes = time / 60
        let seconds = time % 60
        let timeString = String(format: "正在等待服务器分配资源\n%02d:%02d", minutes, seconds)
        inQueueTimeLabel?.text = timeString
        guard time % triggerInterval == 0 else {
            return
        }
        delegate?.gameInQueueViewControllerIntervalDidArrived(self)
    }
}
