//
//  MailSecurityViewController.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/8/23.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit

class MailSecurityViewController: UIViewController {

    private weak var mailAddressLabel: ExtraSizeLabel?
    private weak var mailAddressTextField: UITextField?
    private weak var captchaTextField: UITextField?
    private weak var sendCaptchaButton: UIButton?
    private weak var operationButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = R.clr.appColor._eed5a0()
        view.layer.cornerRadius = 12
        
        operationButton = CommonButton(title: R.string.localizable.email_bind()).addTo(superView: view).configure({ (button) in
            button.addTarget(self, action: #selector(operationButtonClicked), for: .touchUpInside)
        }).layout(snapKitMaker: { (make) in
            make.size.equalTo(CGSize(width: 212, height: 42))
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        })
        
        /// 这里先把两种情况的UI都创建好，再通过refreshUI函数去显示或隐藏对应的控件
        /// 已绑定邮箱UI
        mailAddressLabel = ExtraSizeLabel().addTo(superView: view).configure { (label) in
            label.backgroundColor = R.clr.appColor._ffe6b1()
            label.textColor = R.clr.appColor._844501()
            label.font = UIFont.size14
            label.layer.cornerRadius = 8
            label.clipsToBounds = true
            label.text = UserManager.shared.mailInBinded
            label.extraHeight = 0
        }.layout { (make) in
            make.left.top.right.equalToSuperview().inset(10)
            make.height.equalTo(40)
        }
        
        /// 未绑定邮箱UI
        mailAddressTextField = CommonTextField(placeHolder: R.string.localizable.input_email()).addTo(superView: view).layout(snapKitMaker: { (make) in
            make.left.top.right.equalToSuperview().inset(10)
            make.height.equalTo(40)
        })
        
        captchaTextField = CommonTextField(placeHolder: R.string.localizable.captcha()).addTo(superView: view).layout(snapKitMaker: { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(mailAddressTextField!.snp.bottom).offset(5)
            make.height.equalTo(40)
            make.width.equalTo(144)
        })
        
        sendCaptchaButton = UIButton().addTo(superView: view).configure({ (button) in
            button.backgroundColor = R.clr.appColor._ff8839()
            button.titleLabel?.font = UIFont.size13
            button.setTitle(R.string.localizable.send_capthca(), for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.layer.cornerRadius = 8
            button.addTarget(self, action: #selector(sendCaptchaButtonClicked), for: .touchUpInside)
        }).layout(snapKitMaker: { (make) in
            make.size.equalTo(CGSize(width: 100, height: 40))
            make.left.equalTo(captchaTextField!.snp.right).offset(5)
            make.top.equalTo(mailAddressTextField!.snp.bottom).offset(5)
        })
        
        refreshUI(mailIfBind: !UserManager.shared.mailInBinded.isEmpty)
    }
    
    private func refreshUI(mailIfBind: Bool) {
        operationButton?.setTitle(mailIfBind ? R.string.localizable.unbind() : R.string.localizable.bind(), for: .normal)
        mailAddressLabel?.isHidden = !mailIfBind
        mailAddressTextField?.isHidden = mailIfBind
        captchaTextField?.isHidden = mailIfBind
        sendCaptchaButton?.isHidden = mailIfBind
    }
    
    @objc private func sendCaptchaButtonClicked() {
        guard mailAddressIfValid() else { return }
        BlockHUD.showLoading(inView: view)
        MailSecurityModuleManager.sendCaptcha(mailAddress: mailAddressTextField!.text!) { (result) in
            BlockHUD.hide(forView: self.view)
            switch result {
            case .success(_):
                AlertController.alert(title: R.string.localizable.send_success_check_mail(), message: nil, from: self)
            case .failure(.emailPatternError):
                AlertController.alert(title: R.string.localizable.email_format_not_valid(), message: nil, from: self)
            case .failure(.emailNotValid):
                AlertController.alert(title: R.string.localizable.email_format_not_valid(), message: nil, from: self)
            case .failure(.emailHasBeenBind):
                AlertController.alert(title: R.string.localizable.email_has_been_used(), message: nil, from: self)
            case .failure(let error):
                self.defaultParseError(error)
            }
        }
    }
    
    @objc private func operationButtonClicked() {
        if UserManager.shared.mailInBinded.isEmpty { // 绑定邮箱
            guard mailAddressIfValid() else { return }
            guard captchaIfValid() else { return }
            BlockHUD.showLoading(inView: view)
            MailSecurityModuleManager.bindMail(mailAddressTextField!.text!, captcha: captchaTextField!.text!) { (result) in
                BlockHUD.hide(forView: self.view)
                switch result {
                case .success(_):
                    AlertController.alert(title: R.string.localizable.bind_success(), message: nil, from: self)
                    self.refreshUI(mailIfBind: true)
                case .failure(.userHasBindEmail):
                    AlertController.alert(title: R.string.localizable.account_has_bind_email(), message: nil, from: self)
                case .failure(.captchaError):
                    AlertController.alert(title: R.string.localizable.the_verification_code_error(), message: nil, from: self)
                case .failure(let error):
                    self.defaultParseError(error)
                }
            }
        }else {
            BlockHUD.showLoading(inView: view)
            MailSecurityModuleManager.unbindMail { [unowned self] (result) in
                BlockHUD.hide(forView: self.view)
                switch result {
                case .success(_):
                    AlertController.alert(title: R.string.localizable.unbind_successful(), message: nil, from: self)
                    self.refreshUI(mailIfBind: false)
                case .failure(.userNotBindEmail):
                    AlertController.alert(title: R.string.localizable.account_not_bind_mail(), message: nil, from: self)
                case .failure(let error):
                    self.defaultParseError(error)
                }
            }
        }
    }
    
    private func captchaIfValid() -> Bool {
        guard let captcha = captchaTextField?.text, !captcha.isEmpty else {
            AlertController.alert(title: R.string.localizable.input_verification_code(), message: nil, from: self)
            return false
        }
        guard RegexMatcher.match(captcha: captcha, length: 6) else {
            AlertController.alert(title: R.string.localizable.verofication_code_format_not_valid(), message: nil, from: self)
            return false
        }
        return true
    }
    
    private func mailAddressIfValid() -> Bool {
        guard let mailAddress = mailAddressTextField?.text, !mailAddress.isEmpty else {
            AlertController.alert(title: R.string.localizable.input_email(), message: nil, from: self)
            return false
        }
        guard RegexMatcher.match(mail: mailAddress) else {
            AlertController.alert(title: R.string.localizable.password_not_match(), message: nil, from: self)
            return false
        }
        return true
    }
}
