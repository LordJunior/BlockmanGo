//
//  ThirdLoginSecurityOptionTableViewCell.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/8/24.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit

class ThirdSignSecurityOptionTableViewCell: UITableViewCell {

    var platform: SignInPlatformEnum = .app {
        didSet {
            switch platform {
            case .facebook:
                optionImageView?.image = R.image.general_facebook()
                optionTitleLabel?.text = "Facebook"
            case .twitter:
                optionImageView?.image = R.image.general_twitter()
                optionTitleLabel?.text = "Twitter"
            case .google:
                optionImageView?.image = R.image.general_google()
                optionTitleLabel?.text = "Google+"
            default:
                break
            }
        }
    }
    
    var isBinding: Bool = false {
        didSet {
            optionStatusButton?.setTitle(isBinding ? "解绑" : "绑定", for: .normal)
            optionStatusButton?.backgroundColor = isBinding ? R.clr.appColor._d3b26c() : R.clr.appColor._ff8839()
        }
    }
    
    private weak var backgroundImageView: UIImageView?
    private weak var optionImageView: UIImageView?
    private weak var optionTitleLabel: UILabel?
    private weak var optionStatusButton: UIButton?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        backgroundImageView = UIImageView(image: R.image.setting_option()).addTo(superView: contentView).layout { (make) in
            make.left.right.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview()
        }
        
        optionImageView = UIImageView().addTo(superView: backgroundImageView!).layout { (make) in
            make.left.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
        }.configure({ (imageView) in
            imageView.image = R.image.general_facebook()
        })
        
        optionTitleLabel = UILabel().addTo(superView: backgroundImageView!).configure({ (label) in
            label.textColor = R.clr.appColor._844501()
            label.font = UIFont.size13
            label.text = "垃圾游戏"
        }).layout(snapKitMaker: { (make) in
            make.left.equalTo(optionImageView!.snp.right).offset(10)
            make.centerY.equalToSuperview()
        })
        
        optionStatusButton = UIButton().addTo(superView: backgroundImageView!).configure({ (button) in
            button.backgroundColor = R.clr.appColor._ff8839()
            button.titleLabel?.font = UIFont.size11
            button.setTitle("Binding", for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.layer.cornerRadius = 12
            button.isUserInteractionEnabled = false
        }).layout(snapKitMaker: { (make) in
            make.size.equalTo(CGSize(width: 60, height: 24))
            make.right.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
