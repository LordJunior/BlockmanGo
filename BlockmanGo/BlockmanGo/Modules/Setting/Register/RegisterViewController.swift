//
//  RegisterViewController.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/8/24.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    private weak var passwordTextfield: UITextField?
    private weak var confirmPasswordTextfield: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        let backgroundView = UIImageView(image: R.image.general_alert_background()).addTo(superView: view).layout { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 296, height: 270))
        }.configure { (imageView) in
            imageView.isUserInteractionEnabled = true
        }
        
        let registerTipsLabel = ExtraSizeLabel().addTo(superView: backgroundView).configure { (label) in
            label.backgroundColor = R.clr.appColor._89d250()
            label.textColor = UIColor.white
            label.font = UIFont.size12
            label.layer.cornerRadius = 12
            label.clipsToBounds = true
            label.text = "注册成功，请设置密码"
            label.contentInset = UIEdgeInsetsMake(0, 10, 0, 0)
        }.layout { (make) in
            make.left.right.top.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
        
        let inputPasswordContainView = UIView().addTo(superView: backgroundView).configure { (view) in
            view.backgroundColor = R.clr.appColor._eed5a0()
            view.layer.cornerRadius = 12
        }.layout { (make) in
            make.top.equalTo(registerTipsLabel.snp.bottom).offset(5)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
        
        passwordTextfield = CommonTextField(placeHolder: "输入密码").addTo(superView: inputPasswordContainView).layout(snapKitMaker: { (make) in
            make.left.right.top.equalToSuperview().inset(10)
            make.height.equalTo(40)
        })
        
        confirmPasswordTextfield = CommonTextField(placeHolder: "确认密码").addTo(superView: inputPasswordContainView).layout(snapKitMaker: { (make) in
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(40)
            make.top.equalTo(passwordTextfield!.snp.bottom).offset(5)
        })
        
        let passwordGuidelineLabel = ExtraSizeLabel().addTo(superView: inputPasswordContainView).configure { (label) in
            label.textColor = R.clr.appColor._b17f63()
            label.font = UIFont.size11
            label.text = "6-16个英文字母或数字"
        }.layout { (make) in
            make.left.right.equalToSuperview().inset(10)
            make.top.equalTo(confirmPasswordTextfield!.snp.bottom).offset(3)
        }
        
        CommonButton(title: R.string.localizable.done()).addTo(superView: inputPasswordContainView).layout { (make) in
            make.size.equalTo(CGSize(width: 212, height: 42 ))
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }.configure { (button) in
            button.addTarget(self, action: #selector(registerButtonClicked), for: .touchUpInside)
        }
        
        addCloseButton(layout: { (make) in
            make.size.equalTo(closeButtonSize)
            make.left.equalTo(backgroundView.snp.right).offset(5)
            make.top.equalTo(backgroundView)
        }) { (_) in
            TransitionManager.dismiss(animated: true)
        }
    }
    
    @objc private func registerButtonClicked() {
        guard let password = passwordTextfield?.text, !password.isEmpty else {
            AlertController.alert(title: "请输入密码", message: nil, from: self)
            return
        }
        guard RegexMatcher.match(password: password) else {
            AlertController.alert(title: "密码不合法，请重新输入", message: nil, from: self)
            return
        }
        guard password == confirmPasswordTextfield?.text else {
            AlertController.alert(title: "密码不匹配", message: nil, from: self)
            return
        }
    }
}
