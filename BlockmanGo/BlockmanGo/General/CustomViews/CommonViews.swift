//
//  CommonViews.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/8/23.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation

class CommonTextField: UITextField {
    
    required init(placeHolder: String?, fontSize: CGFloat = 14, textColor: UIColor = R.clr.appColor._844501()) {
        super.init(frame: .zero)
        
        placeholder = placeHolder
        font = UIFont.systemFont(ofSize: fontSize)
        backgroundColor = R.clr.appColor._fff8e9()
        layer.cornerRadius = 8
        clipsToBounds = true
        self.textColor = textColor
        leftViewMode = .always
        leftView = UIView().addTo(superView: self).layout(snapKitMaker: { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(10)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CommonButton: UIButton {
    required init(title: String?, fontSize: CGFloat = 14) {
        super.init(frame: .zero)
        
        setBackgroundImage(R.image.general_button_background_selected(), for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSize)
        setTitle(title, for: .normal)
        setTitleColor(R.clr.appColor._844501(), for: .normal)
        titleEdgeInsets = UIEdgeInsetsMake(-2, 0, 0, 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
