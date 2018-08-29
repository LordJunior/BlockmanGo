//
//  AccountInfoView.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/10.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit

class AccountInfoView: UIView {

    var portraitURL: String? {
        didSet {
            portraitView?.imageWithUrlString(portraitURL, placeHolder: R.image.common_default_userimage())
        }
    }
    
    var nickname: String? {
        didSet {
            nicknameLabel?.text = nickname
        }
    }
    
    var userID: String? {
        didSet {
            userIDLabel?.text = "ID: " + (userID ?? "")
        }
    }
    
    var gender: Gender? {
        didSet {
            genderImageView?.image = gender == .male ? R.image.gender_male() : R.image.gender_female()
        }
    }
    
    var vipLevel: Int = 0 {
        didSet {
            vipLevelImageView?.image = UIImage(named: "vip_\(vipLevel)")
        }
    }
    
    private weak var portraitView: NetImageView?
    private weak var genderImageView: UIImageView?
    private weak var nicknameLabel: UILabel?
    private weak var userIDLabel: UILabel?
    private weak var vipLevelImageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        portraitView = NetImageView(image: R.image.common_default_userimage()).addTo(superView: self).layout { (make) in
            make.left.equalToSuperview().offset(5)
            make.size.equalTo(CGSize(width: 42, height: 42))
            make.centerY.equalToSuperview()
        }.configure { (imageView) in
            imageView.layer.cornerRadius = 5
            imageView.clipsToBounds = true
        }
        
        let backgroundImageView = UIImageView(image: R.image.account_info_background()).addTo(superView: self).layout { (make) in
            make.edges.equalToSuperview()
        }
        
        genderImageView = UIImageView().addTo(superView: backgroundImageView).layout(snapKitMaker: { (make) in
            make.left.equalToSuperview().offset(32)
            make.bottom.equalToSuperview().inset(5)
        })
        
        nicknameLabel = UILabel().addTo(superView: backgroundImageView).configure({ (label) in
            label.font = UIFont.size14
            label.textColor = R.clr.appColor._5e3f00()
        }).layout(snapKitMaker: { (make) in
            make.left.equalTo(genderImageView!.snp.right).offset(5)
            make.top.equalToSuperview().offset(14)
        })
        
        userIDLabel = UILabel().addTo(superView: backgroundImageView).configure({ (label) in
            label.font = UIFont.size11
            label.textColor = R.clr.appColor._b39558()
        }).layout(snapKitMaker: { (make) in
            make.left.equalTo(genderImageView!.snp.right).offset(5)
            make.top.equalTo(nicknameLabel!.snp.bottom).offset(3)
        })
        
        vipLevelImageView = UIImageView().addTo(superView: backgroundImageView).layout(snapKitMaker: { (make) in
            make.right.bottom.equalToSuperview()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
