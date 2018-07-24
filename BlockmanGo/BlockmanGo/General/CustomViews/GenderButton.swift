//
//  GenderButton.swift
//  BlockmanGo
//
//  Created by KiBen Hung on 2018/7/21.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit

class GenderButton: UIButton {

    required init(gender: Gender) {
        super.init(frame: .zero)
        
        titleLabel?.font = UIFont.size15
        setTitle(gender == .male ? "男" : "女", for: .normal)
        setTitleColor(R.clr.appColor._844501(), for: .normal)
        setBackgroundImage(R.image.general_option(), for: .normal)
        setBackgroundImage(R.image.general_option_selected(), for: .selected)
        UIImageView(image: gender == .male ? R.image.gender_male() : R.image.gender_female()).addTo(superView: self).layout(snapKitMaker: { (make) in
            make.left.top.equalToSuperview()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
