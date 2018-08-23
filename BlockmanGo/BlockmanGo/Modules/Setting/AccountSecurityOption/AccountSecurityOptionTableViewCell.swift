//
//  AccountSecurityOptionTableViewCell.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/8/23.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit

class AccountSecurityOptionTableViewCell: UITableViewCell {

    var optionTitle: String? {
        didSet {
            titleLabel?.text = optionTitle
        }
    }
    
    private weak var titleLabel: UILabel?
    private weak var backgroundImageView: UIImageView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        backgroundImageView = UIImageView().addTo(superView: contentView).layout { (make) in
            make.left.right.equalToSuperview().inset(13)
            make.top.bottom.equalToSuperview()
        }
        
        titleLabel = UILabel().addTo(superView: contentView).configure { (label) in
            label.textColor = R.clr.appColor._844501()
            label.font = UIFont.size14
        }.layout { (make) in
            make.left.equalToSuperview().offset(30)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            backgroundImageView?.image = R.image.setting_option()
        }else {
            backgroundImageView?.image = nil
        }
    }
}
