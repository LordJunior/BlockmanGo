//
//  GameModesTableCell.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/11.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit
import SnapKit

class GameModesTableCell: UITableViewCell {

    var modeTitle: String? {
        didSet {
            titleLabel?.text = modeTitle
        }
    }
    
    private var backgroundImageViewToSuperRightConstraint: Constraint?
    private weak var titleLabel: UILabel?
    private weak var backgroundImageView: UIImageView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        selectionStyle = .none
        
        backgroundImageView = UIImageView(image: R.image.general_button_background_normal()).addTo(superView: contentView).layout { (make) in
            make.left.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(7)
            self.backgroundImageViewToSuperRightConstraint = make.right.equalToSuperview().inset(16).constraint
        }
        
        titleLabel = UILabel().addTo(superView: backgroundImageView!).layout { (make) in
            make.center.equalToSuperview()
        }.configure({ (label) in
            label.font = UIFont.boldSize15
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            titleLabel?.textColor = R.clr.appColor._844501()
            backgroundImageView?.image = R.image.general_button_background_selected()
            backgroundImageViewToSuperRightConstraint?.update(inset: 0)
        }else {
            titleLabel?.textColor = UIColor.white
            backgroundImageView?.image = R.image.general_button_background_normal()
            backgroundImageViewToSuperRightConstraint?.update(inset: 34)
        }
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }

}
