//
//  MailSecurityViewController.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/8/23.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit

class MailSecurityViewController: UIViewController {

    private weak var mailAddressTextField: UITextField?
    private weak var captchaTextField: UITextField?
    private weak var sendCaptchaButton: UIButton?
    private weak var operationButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = R.clr.appColor._eed5a0()
        view.layer.cornerRadius = 12
        
        operationButton = CommonButton(title: "绑定邮箱").addTo(superView: view).configure({ (button) in
            
        }).layout(snapKitMaker: { (make) in
            make.size.equalTo(CGSize(width: 212, height: 42))
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        })
        
        let random = arc4random() % 100
        if random > 50 { // 已绑定过邮箱
            operationButton?.setTitle("接触绑定", for: .normal)
            UILabel().addTo(superView: view).configure { (label) in
                label.backgroundColor = R.clr.appColor._ffe6b1()
                label.textColor = R.clr.appColor._844501()
                label.font = UIFont.size14
                label.layer.cornerRadius = 8
                label.clipsToBounds = true
                label.text = "ssfsfsfhjwrke@qq.com"
            }.layout { (make) in
                make.left.top.right.equalToSuperview().inset(10)
                make.height.equalTo(40)
            }
        }else {
            mailAddressTextField = CommonTextField(placeHolder: "绑定邮箱").addTo(superView: view).layout(snapKitMaker: { (make) in
                make.left.top.right.equalToSuperview().inset(10)
                make.height.equalTo(40)
            })
            
            captchaTextField = CommonTextField(placeHolder: "验证码").addTo(superView: view).layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(10)
                make.top.equalTo(mailAddressTextField!.snp.bottom).offset(5)
                make.height.equalTo(40)
                make.width.equalTo(144)
            })
            
            sendCaptchaButton = UIButton().addTo(superView: view).configure({ (button) in
                button.backgroundColor = R.clr.appColor._ff8839()
                button.titleLabel?.font = UIFont.size13
                button.setTitle("发送验证码", for: .normal)
                button.setTitleColor(UIColor.white, for: .normal)
                button.layer.cornerRadius = 8
            }).layout(snapKitMaker: { (make) in
                make.size.equalTo(CGSize(width: 100, height: 40))
                make.left.equalTo(captchaTextField!.snp.right).offset(5)
                make.top.equalTo(mailAddressTextField!.snp.bottom).offset(5)
            })
        }
    }
}
