//
//  RegisterViewController.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/8/24.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit
protocol RegisterViewControllerDelegate: class {
    func registerDidSuccessful()
}

class RegisterViewController: UIViewController {

    weak var delegate: RegisterViewControllerDelegate?
    
    private weak var passwordTextfield: UITextField?
    private weak var confirmPasswordTextfield: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        if parameter != nil {
            delegate = parameter as? RegisterViewControllerDelegate
        }
        
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
            label.text = R.string.localizable.register_succeed_then_set_password()
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
        
        passwordTextfield = CommonTextField(placeHolder: R.string.localizable.input_password()).addTo(superView: inputPasswordContainView).layout(snapKitMaker: { (make) in
            make.left.right.top.equalToSuperview().inset(10)
            make.height.equalTo(40)
        }).configure({ (textField) in
            textField.isSecureTextEntry = true
        })
        
        confirmPasswordTextfield = CommonTextField(placeHolder: R.string.localizable.confirm_password()).addTo(superView: inputPasswordContainView).layout(snapKitMaker: { (make) in
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(40)
            make.top.equalTo(passwordTextfield!.snp.bottom).offset(5)
        }).configure({ (textField) in
            textField.isSecureTextEntry = true
        })
        
        ExtraSizeLabel().addTo(superView: inputPasswordContainView).configure { (label) in
            label.textColor = R.clr.appColor._b17f63()
            label.font = UIFont.size11
            label.text = R.string.localizable.six_to_twelve_digits_or_letters()
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
        /// 注册这一步的流程是
        /// 在用户填写完密码后，重新调用auth-token接口去生成新账号
        /// 然后再去设置密码
        regenerateAuth()
    }
    
    private func regenerateAuth() {
        BlockHUD.showLoading(inView: view)
        RegisterModuleManager.regenerateAuthorization { (result) in
            switch result {
            case .success(_):
                self.setPassword()
            case .failure(let error):
                BlockHUD.hide(forView: self.view)
                self.defaultParseError(error)
            }
        }
    }
    
    private func setPassword() {
        PasswordSecurityModuleManager.setPassword(passwordTextfield!.text!) { (result) in
            BlockHUD.hide(forView: self.view)
            switch result {
            case .success(_):
                AlertController.alert(title: "注册成功", message: nil, from: self)?.done(completion: { _ in
                    self.delegate?.registerDidSuccessful()
                })
            case .failure(let error):
                self.defaultParseError(error)
            }
        }
    }
}
