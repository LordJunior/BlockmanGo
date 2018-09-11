//
//  AboutUsViewController.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/8/24.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        let backgroundView = UIImageView(image: R.image.general_alert_background()).addTo(superView: view).layout { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 310, height: 264))
        }
        
        let appInfoContainView = UIView().addTo(superView: backgroundView).configure { (view) in
            view.backgroundColor = R.clr.appColor._eed5a0()
            view.layer.cornerRadius = 12
        }.layout { (make) in
            make.edges.equalToSuperview().inset(20)
        }
        
        let appIconImageView = UIImageView(image: R.image.general_app_icon()).addTo(superView: appInfoContainView).layout { (make) in
            make.size.equalTo(CGSize(width: 60, height: 60))
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        
        let appNameLabel = UILabel().addTo(superView: appInfoContainView).configure({ (label) in
            label.font = UIFont.size13
            label.textColor = R.clr.appColor._844501()
            label.text = "Blockman GO"
        }).layout(snapKitMaker: { (make) in
            make.top.equalTo(appIconImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        })
        
        UILabel().addTo(superView: appInfoContainView).configure({ (label) in
            label.font = UIFont.size11
            label.textColor = R.clr.appColor._a36b2e()
            label.text = "v\(AppInfo.currentShortVersion)" + " Engine:\(GameEngineInfo.engineVersion) Res:\(GameEngineInfo.resourceVersion)"
        }).layout(snapKitMaker: { (make) in
            make.top.equalTo(appNameLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        })
        
        UILabel().addTo(superView: appInfoContainView).configure({ (label) in
            label.font = UIFont.size10
            label.textColor = R.clr.appColor._a36b2e()
            label.numberOfLines = 0
            label.text = "Copyright© 2015-2018"
        }).layout(snapKitMaker: { (make) in
            make.bottom.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
        })
        
        addCloseButton(layout: { (make) in
            make.size.equalTo(closeButtonSize)
            make.left.equalTo(backgroundView.snp.right).offset(5)
            make.top.equalTo(backgroundView)
        }) { _ in
            TransitionManager.dismiss(animated: true)
        }
    }

}
