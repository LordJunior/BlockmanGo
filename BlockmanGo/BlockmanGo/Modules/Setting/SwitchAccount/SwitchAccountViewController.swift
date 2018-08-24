//
//  SwitchAccountViewController.swift
//  BlockmanGo
//
//  Created by KiBen Hung on 2018/8/23.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit

class SwitchAccountViewController: UIViewController {

    private weak var accountTypeImageView: UIImageView?
    private weak var idLabel: UILabel?
    private weak var nicknameLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        let containView = UIImageView(image: R.image.general_alert_background()).addTo(superView: view).layout { (make) in
            make.size.equalTo(CGSize(width: 310, height: 200))
            make.center.equalToSuperview()
        }.configure { (imageView) in
            imageView.isUserInteractionEnabled = true
        }
        
        let shadowContainView = UIView().addTo(superView: containView).configure { (view) in
            view.backgroundColor = R.clr.appColor._eed5a0()
            view.layer.cornerRadius = 12
            view.clipsToBounds = true
        }.layout { (make) in
            make.left.right.top.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        
        let idContainView = UIView().addTo(superView: shadowContainView).configure { (view) in
            view.layer.cornerRadius = 8
            view.clipsToBounds = true
            view.backgroundColor = UIColor.white
        }.layout { (make) in
            make.left.right.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(20)
        }
        
        accountTypeImageView = UIImageView(image: R.image.setting_Facebook()).addTo(superView: idContainView).layout(snapKitMaker: { (make) in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 34, height: 34))
        })
        
        idLabel = UILabel().addTo(superView: idContainView).configure({ (label) in
            label.font = UIFont.size13
            label.textColor = R.clr.appColor._844501()
            label.text = "ID: 1234567"
        }).layout(snapKitMaker: { (make) in
            make.left.equalTo(accountTypeImageView!.snp.right).offset(10)
            make.centerY.equalTo(accountTypeImageView!).offset(-8)
        })
        
        nicknameLabel = UILabel().addTo(superView: idContainView).configure({ (label) in
            label.font = UIFont.size12
            label.textColor = R.clr.appColor._aaaaaa()
            label.text = "昵称: 垃圾游戏"
        }).layout(snapKitMaker: { (make) in
            make.left.equalTo(idLabel!)
            make.top.equalTo(idLabel!.snp.bottom).offset(5)
        })
        
        UIImageView(image: R.image.setting_checked()).addTo(superView: idContainView).layout { (make) in
            make.size.equalTo(CGSize(width: 12, height: 12))
            make.right.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
        
        CommonButton(title: "切换账号").addTo(superView: containView).configure { (button) in
            button.addTarget(self, action: #selector(switchAccountButtonClicked), for: .touchUpInside)
        }.layout { (make) in
            make.size.equalTo(CGSize(width: 212, height: 42))
            make.centerX.equalToSuperview()
            make.top.equalTo(shadowContainView.snp.bottom).offset(15)
        }
        
        addCloseButton(layout: { (make) in
            make.size.equalTo(closeButtonSize)
            make.left.equalTo(containView.snp.right).offset(5)
            make.top.equalTo(containView)
        }) { _ in
            TransitionManager.dismiss(animated: true)
        }
    }
    
    @objc private func switchAccountButtonClicked() {
        
    }
}
