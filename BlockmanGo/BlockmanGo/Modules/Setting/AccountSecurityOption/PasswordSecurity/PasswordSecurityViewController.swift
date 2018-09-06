//
//  PasswordSecurityViewController.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/8/23.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit

class PasswordSecurityViewController: UIViewController {
    
    private weak var originPasswordTextField: UITextField?
    private weak var newPasswordTextField: UITextField?
    private weak var confirmPasswordTextField: UITextField?
    private weak var operationButton: UIButton?
    
    private let passwordSecurityManager = PasswordSecurityModuleManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = R.clr.appColor._eed5a0()
        view.layer.cornerRadius = 12
        
        originPasswordTextField = CommonTextField(placeHolder: "输入密码").addTo(superView: view).layout(snapKitMaker: { (make) in
            make.left.top.right.equalToSuperview().inset(10)
            make.height.equalTo(40)
        })
        
        newPasswordTextField = CommonTextField(placeHolder: "重复密码").addTo(superView: view).layout(snapKitMaker: { (make) in
            make.size.centerX.equalTo(originPasswordTextField!)
            make.top.equalTo(originPasswordTextField!.snp.bottom).offset(5)
        })
        
        operationButton = CommonButton(title: "设置密码").addTo(superView: view).layout(snapKitMaker: { (make) in
            make.size.equalTo(CGSize(width: 212, height: 42))
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }).configure({ (button) in
            button.addTarget(self, action: #selector(operationButtonClicked), for: .touchUpInside)
        })
        
        if UserManager.shared.passwordIfHave() { // 已设置过密码，更新密码
            refreshToModifyPasswordUI()
        }
    }

    @objc private func operationButtonClicked() {
        if UserManager.shared.passwordIfHave() { // 已设置过密码，更新密码
            guard let password = originPasswordTextField?.text, !password.isEmpty else {
                AlertController.alert(title: "请输入原密码", message: nil, from: self)
                return
            }
            guard let newPassword = newPasswordTextField?.text, !newPassword.isEmpty else {
                AlertController.alert(title: "请输入新密码", message: nil, from: self)
                return
            }
            guard RegexMatcher.match(password: newPassword) else {
                AlertController.alert(title: "密码不合法，请重新输入", message: nil, from: self)
                return
            }
            guard newPassword == confirmPasswordTextField?.text else {
                AlertController.alert(title: "密码不匹配，请检查", message: nil, from: self)
                return
            }
            
            BlockHUD.showLoading(inView: view)
            PasswordSecurityModuleManager.modifyPassword(origin: password, new: newPassword) { [unowned self] (result) in
                BlockHUD.hide(forView: self.view)
                switch result {
                case .success(_):
                    AlertController.alert(title: R.string.localizable.modify_success(), message: nil, from: TransitionManager.rootViewController)
                    self.clearText()
                    
                case .failure(let error):
                    self.defaultParseError(error)
                }
            }
        }else {
            guard let password = originPasswordTextField?.text, !password.isEmpty else {
                AlertController.alert(title: "请输入密码", message: nil, from: self)
                return
            }
            guard RegexMatcher.match(password: password) else {
                AlertController.alert(title: "密码不合法，请重新输入", message: nil, from: self)
                return
            }
            guard password == newPasswordTextField?.text else {
                AlertController.alert(title: "密码不匹配，请检查", message: nil, from: self)
                return
            }
            
            BlockHUD.showLoading(inView: view)
            PasswordSecurityModuleManager.setPassword(password) {[unowned self] (result) in
                BlockHUD.hide(forView: self.view)
                switch result {
                case .success(_):
                    AlertController.alert(title: "设置成功", message: nil, from: TransitionManager.rootViewController)
                    UserManager.shared.didSetPassword() /// 设置密码
                    self.refreshToModifyPasswordUI()
                    self.clearText()
                case .failure(let error):
                    self.defaultParseError(error)
                }
            }
        }
    }
    
    private func clearText() {
        originPasswordTextField?.text = nil
        newPasswordTextField?.text = nil
        confirmPasswordTextField?.text = nil
    }
    
    private func refreshToModifyPasswordUI() {
        originPasswordTextField?.placeholder = "输入旧密码"
        newPasswordTextField?.placeholder = "输入新密码"
        operationButton?.setTitle("确认修改", for: .normal)
        confirmPasswordTextField = CommonTextField(placeHolder: "重复新密码").addTo(superView: view).layout(snapKitMaker: { (make) in
            make.size.centerX.equalTo(newPasswordTextField!)
            make.top.equalTo(newPasswordTextField!.snp.bottom).offset(5)
        })
    }
}
