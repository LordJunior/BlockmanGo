//
//  LoginViewController.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/8/23.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate: class {
    func loginViewControllerDidCancel(_ viewController: LoginViewController)
    func loginViewControllerDidLoginSuccessful(_ viewController: LoginViewController)
}

/// parameter为(Bool, LoginViewControllerDelegate)元组值，第一个参数 是否为验证失败需要重新登录；第二个参数是传代理对象
class LoginViewController: UIViewController {

    weak var delegate: LoginViewControllerDelegate?
    
    private enum SignPlatform: Int {
        case facebook
        case twitter
        case google
    }
    
    private weak var accountTextField: UITextField?
    private weak var passwordTextField: UITextField?
    private weak var registerButton: UIButton?
    private weak var mailButton: UIButton?
    private weak var loginButton: UIButton?
    private weak var twitterButton: AdjustLayoutButton?
    private weak var facebookButton: AdjustLayoutButton?
    private weak var googleButton: AdjustLayoutButton?
    
    private var isAuthorizationExpired = false
    private let googleSignInService = GoogleSignService()
    private var facebookSignInService: FacebookSignService?
    
    deinit {
        print("LoginViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        googleSignInService.delegate = self
        googleSignInService.uiDelegate = self
        facebookSignInService = FacebookSignService(from: self)
        facebookSignInService?.delegate = self
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        if let (isExpired, loginControllerDelegate) = parameter as? (Bool, LoginViewControllerDelegate?) {
            isAuthorizationExpired = isExpired
            delegate = loginControllerDelegate
        }
        
        let containView = UIImageView(image: R.image.general_alert_background()).addTo(superView: view).configure { (imageView) in
            imageView.isUserInteractionEnabled = true
        }.layout { (make) in
            make.width.equalTo(310)
            make.center.equalToSuperview()
        }
        
        var topLabel = UILabel()
        if isAuthorizationExpired { // 验证失效，重新登录
            topLabel = ExtraSizeLabel().addTo(superView: containView).configure { (label) in
                label.backgroundColor = R.clr.appColor._ed8b74()
                label.textColor = UIColor.white
                label.font = UIFont.size12
                label.text = "登录状态已经失效，请重新登录！"
                label.layer.cornerRadius = 12
                label.clipsToBounds = true
                label.contentInset = UIEdgeInsetsMake(0, 10, 0, 0)
            }.layout { (make) in
                make.left.right.top.equalToSuperview().inset(20)
                make.height.equalTo(30)
            }
        }else { // 切换账号
            topLabel = UILabel().addTo(superView: containView).configure { (label) in
                label.textColor = R.clr.appColor._844501()
                label.font = UIFont.size13
                label.text = "当前ID: \(UserManager.shared.userID)"
            }.layout { (make) in
                make.left.top.equalToSuperview().offset(20)
            }
        }
        
        let shadowContainView = UIView().addTo(superView: containView).configure { (view) in
            view.backgroundColor = R.clr.appColor._eed5a0()
            view.layer.cornerRadius = 12
        }.layout { (make) in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(topLabel.snp.bottom).offset(isAuthorizationExpired ? 12 : 5)
            make.height.equalTo(192)
        }
        
        accountTextField = CommonTextField(placeHolder: "输入账号/ID").addTo(superView: shadowContainView).layout(snapKitMaker: { (make) in
            make.left.right.top.equalToSuperview().inset(10)
            make.height.equalTo(40)
        }).configure({ (textField) in
            textField.text = "\(UserManager.shared.userID)"
        })
        
        passwordTextField = CommonTextField(placeHolder: "输入密码").addTo(superView: shadowContainView).configure({ (textfield) in
            textfield.isSecureTextEntry = true
        }).layout(snapKitMaker: { (make) in
            make.top.equalTo(accountTextField!.snp.bottom).offset(5)
            make.size.centerX.equalTo(accountTextField!)
        })
        
        let buttonConfig = {(button: UIButton) in
            button.backgroundColor = R.clr.appColor._94d559()
            button.layer.cornerRadius = 8
            button.titleLabel?.font = UIFont.size11
            button.setTitleColor(UIColor.white, for: .normal)
        }
        registerButton = UIButton().addTo(superView: shadowContainView).configure(buttonConfig).configure({ (button) in
            button.setTitle("账号注册", for: .normal)
            button.addTarget(self, action: #selector(registerButtonClicked), for: .touchUpInside)
        }).layout(snapKitMaker: { (make) in
            make.top.equalTo(passwordTextField!.snp.bottom).offset(7)
            make.height.equalTo(20)
            make.width.greaterThanOrEqualTo(60)
            make.left.equalTo(passwordTextField!)
        })
        
        mailButton = UIButton().addTo(superView: shadowContainView).configure(buttonConfig).configure({ (button) in
            button.setTitle("邮箱找回", for: .normal)
            button.addTarget(self, action: #selector(mailButtonClicked), for: .touchUpInside)
        }).layout(snapKitMaker: { (make) in
            make.top.equalTo(passwordTextField!.snp.bottom).offset(7)
            make.height.equalTo(20)
            make.width.greaterThanOrEqualTo(60)
            make.right.equalTo(passwordTextField!)
        })
        
        loginButton = CommonButton(title: R.string.localizable.log_in()).addTo(superView: shadowContainView).configure({ (button) in
            button.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        }).layout(snapKitMaker: { (make) in
            make.size.equalTo(CGSize(width: 212, height: 42))
            make.top.equalTo(mailButton!.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        })
        
        let thirdLoginButtonConfig = {(button: AdjustLayoutButton) in
            button.titleLabel?.font = UIFont.size11
            button.setTitleColor(R.clr.appColor._844501(), for: .normal)
            button.padding = 5
            button.contentLayout = .imageTopTitleBottom
        }
//        twitterButton = AdjustLayoutButton().addTo(superView: containView).configure { (button) in
//            button.setImage(R.image.setting_Twitter(), for: .normal)
//            button.setTitle("Twitter", for: .normal)
//        }.configure(thirdLoginButtonConfig).layout { (make) in
//            make.top.equalTo(shadowContainView.snp.bottom).offset(20)
//            make.centerX.equalToSuperview()
//            make.size.equalTo(CGSize(width: 60, height: 60))
//        }
        
        facebookButton = AdjustLayoutButton().addTo(superView: containView).configure { (button) in
            button.setImage(R.image.setting_Facebook(), for: .normal)
            button.setTitle("Facebook", for: .normal)
            button.tag = SignPlatform.facebook.rawValue
            button.addTarget(self, action: #selector(thirdSignButtonClicked(_:)), for: .touchUpInside)
        }.configure(thirdLoginButtonConfig).layout { (make) in
            make.size.equalTo(CGSize(width: 60, height: 60))
            make.top.equalTo(shadowContainView.snp.bottom).offset(20)
            make.centerX.equalToSuperview().multipliedBy(0.4)
        }
        
        googleButton = AdjustLayoutButton().addTo(superView: containView).configure { (button) in
            button.setImage(R.image.setting_Google(), for: .normal)
            button.setTitle("Google+", for: .normal)
            button.tag = SignPlatform.google.rawValue
            button.addTarget(self, action: #selector(thirdSignButtonClicked(_:)), for: .touchUpInside)
        }.configure(thirdLoginButtonConfig).layout { (make) in
            make.size.equalTo(facebookButton!)
            make.top.equalTo(shadowContainView.snp.bottom).offset(20)
            make.centerX.equalToSuperview().multipliedBy(1.6)
        }
        
        containView.layout { (make) in
            make.bottom.equalTo(googleButton!.snp.bottom).offset(20)
        }
        
        addCloseButton(layout: { (make) in
            make.size.equalTo(closeButtonSize)
            make.top.equalTo(containView)
            make.left.equalTo(containView.snp.right).offset(5)
        }) { _ in
            self.delegate?.loginViewControllerDidCancel(self)
        }
    }
    
    @objc private func registerButtonClicked() {
        TransitionManager.presentInHidePresentingTransition(RegisterViewController.self)
    }
    
    @objc private func mailButtonClicked() {
        
    }
    
    @objc private func thirdSignButtonClicked(_ sender: AdjustLayoutButton) {
        let platform = SignPlatform(rawValue: sender.tag)!
        switch platform {
        case .facebook:
            facebookSignInService?.signIn()
        case .google:
            googleSignInService.signIn()
        default:
            break
        }
    }
    
    @objc private func loginButtonClicked() {
        guard let account = accountTextField?.text, !account.isEmpty else {
            AlertController.alert(title: "请输入账号", message: nil, from: self)
            return
        }
        guard let password = passwordTextField?.text, !password.isEmpty else {
            AlertController.alert(title: "请输入密码", message: nil, from: self)
            return
        }
        BlockHUD.showLoading(inView: view)
        login(account: account, password: password)
    }
    
    private func login(account: String, password: String) {
        LoginModelManager.login(account: account, password: password) { [unowned self] (result) in
            BlockHUD.hide(forView: self.view)
            switch result {
            case .success(_):
                self.delegate?.loginViewControllerDidLoginSuccessful(self)
            case .failure(.accountNotExist):
                AlertController.alert(title: R.string.localizable.the_account_not_exist(), message: nil, from: self)
            case .failure(.passwordError):
                AlertController.alert(title: R.string.localizable.the_password_error(), message: nil, from: self)
            default:
                AlertController.alert(title: R.string.localizable.common_request_fail_retry(), message: nil, from: self)
            }
        }
    }
}

extension LoginViewController: GoogleSignServiceDelegate, GoogleSignServiceUIDelegate {
    func sign(inWillDispath signIn: GoogleSignService) {
        BlockHUD.showLoading(inView: view)
    }
    
    func sign(_ signIn: GoogleSignService, present viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GoogleSignService, dismiss viewController: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GoogleSignService, didSignFor openID: String, token: String) {
        login(account: openID, password: token)
    }
    
    func signDidCanceled(_ signIn: GoogleSignService) {
        BlockHUD.hide(forView: self.view)
    }
    
    func sign(_ signIn: GoogleSignService, didSignFailed: Error) {
        BlockHUD.hide(forView: self.view)
        AlertController.alert(title: "授权失败，请重试", message: nil, from: self)
    }
}

extension LoginViewController: FacebookSignServiceDelegate {
    func signDidCanceled(_ signIn: FacebookSignService) {
        BlockHUD.hide(forView: view)
    }
    
    func sign(_ signIn: FacebookSignService, didSignFor openID: String, token: String) {
        login(account: openID, password: token)
    }
    
    func sign(_ signIn: FacebookSignService, didSignFailed: Error) {
        BlockHUD.hide(forView: self.view)
        AlertController.alert(title: "授权失败，请重试", message: nil, from: self)
    }
}

