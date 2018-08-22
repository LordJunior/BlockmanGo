//
//  SettingTableViewCell.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/8/22.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit

protocol SettingOptionTableViewCellDelegate: class {
    func settingOptionCellDidSelected(_ cell: SettingOptionTableViewCell)
}

class SettingOptionTableViewCell: UITableViewCell {

    weak var delegate: SettingOptionTableViewCellDelegate?
    
    var optionTitle: String? {
        didSet {
            optionButton?.setTitle(optionTitle, for: .normal)
        }
    }
    
    private weak var optionButton: UIButton?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        optionButton = UIButton().addTo(superView: contentView).configure { (button) in
            button.setBackgroundImage(R.image.setting_option(), for: .normal)
            button.setBackgroundImage(R.image.setting_option_selected(), for: .highlighted)
            button.setTitleColor(R.clr.appColor._844501(), for: .normal)
            button.titleLabel?.font = UIFont.size14
            button.addTarget(self, action: #selector(optionButtonClicked), for: .touchUpInside)
        }.layout { (make) in
            make.left.right.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func optionButtonClicked() {
        delegate?.settingOptionCellDidSelected(self)
    }
}
