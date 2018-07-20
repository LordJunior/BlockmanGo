//
//  LaunchProgressView.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/16.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit
import SnapKit

class ProgressView: UIView {

    // 0.0 .. 1.0, default is 0.0. values outside are pinned.
    var progress: Float = 0.0 {
        didSet {
            progress = min(1, max(0, progress))
            progressLabel?.text = String(format: "%d%%", Int(progress * 100))
            updateProgressViewConstraint(progress: progress, animated: false)
        }
    }
    
    var displayInfo: String = "" {
        didSet {
            displayInfoLabel?.text = displayInfo
        }
    }
    
    private weak var progressView: UIImageView?
    private weak var progressLabel: UILabel?
    private weak var displayInfoLabel: UILabel?
    private var progressViewInsetToSuperConstraint: Constraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let background = UIImageView(image: R.image.check_update_progress_background()).addTo(superView: self).layout { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(21)
        }
        
        progressView = UIImageView(image: R.image.check_update_progress()).addTo(superView: background).layout { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0)
        }
        
        let labelConfigure = {(label: UILabel) in
            label.textColor = UIColor.white
            label.font = UIFont.size14
        }
        displayInfoLabel = UILabel().addTo(superView: self).configure(labelConfigure).layout(snapKitMaker: { (make) in
            make.left.bottom.equalToSuperview()
        })
        
        progressLabel = UILabel().addTo(superView: self).configure(labelConfigure).layout(snapKitMaker: { (make) in
            make.right.bottom.equalToSuperview()
        }).configure({ (label) in
            label.text = "0%"
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setProgress(_ progress: Float, animated: Bool) {
        progressLabel?.text = String(format: "%d%%", Int(progress * 100))
        updateProgressViewConstraint(progress: progress, animated: animated)
    }
    
    private func updateProgressViewConstraint(progress: Float, animated: Bool) {
        progressView?.snp.remakeConstraints({ (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(progress)
        })
        guard animated else {return}
        UIView.animate(withDuration: 0.35) {
            self.layoutIfNeeded()
        }
    }
}
