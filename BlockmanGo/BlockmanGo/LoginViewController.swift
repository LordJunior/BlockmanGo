//
//  LoginViewController.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/8/23.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit

/// parameter为Bool值，是否为验证失败需要重新登录
class LoginViewController: UIViewController {

    private weak var accountTextField: UITextField?
    private weak var passwordTextField: UITextField?
    private weak var registerButton: UIButton?
    private weak var mailButton: UIButton?
    private weak var loginButton: UIButton?
    private weak var twitterButton: UIButton?
    private weak var facebookButton: UIButton?
    private weak var googleButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        let containView = UIImageView(image: R.image.general_alert_background()).addTo(superView: view).configure { (imageView) in
            imageView.isUserInteractionEnabled = true
        }.layout { (make) in
            make.width.equalTo(310)
            make.center.equalToSuperview()
        }
        
        var topLabel = UILabel()
        let random = (arc4random() % 100) > 50
        if let param = parameter as? Bool, param { // 验证失效，重新登录
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
                label.text = "当前ID: 1234567"
            }.layout { (make) in
                make.left.top.equalToSuperview().offset(20)
            }
        }
        
        let shadowContainView = UIView().addTo(superView: containView).configure { (view) in
            view.backgroundColor = R.clr.appColor._eed5a0()
            view.layer.cornerRadius = 12
        }.layout { (make) in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(topLabel.snp.bottom).offset(random ? 12 : 5)
            make.height.equalTo(192)
        }
        
        accountTextField = CommonTextField(placeHolder: "输入账号/ID").addTo(superView: shadowContainView).layout(snapKitMaker: { (make) in
            make.left.right.top.equalToSuperview().inset(10)
            make.height.equalTo(40)
        })
        
        passwordTextField = CommonTextField(placeHolder: "输入密码").addTo(superView: shadowContainView).layout(snapKitMaker: { (make) in
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
        }).layout(snapKitMaker: { (make) in
            make.top.equalTo(passwordTextField!.snp.bottom).offset(7)
            make.height.equalTo(20)
            make.width.greaterThanOrEqualTo(60)
            make.left.equalTo(passwordTextField!)
        })
        
        mailButton = UIButton().addTo(superView: shadowContainView).configure(buttonConfig).configure({ (button) in
            button.setTitle("邮箱找回", for: .normal)
        }).layout(snapKitMaker: { (make) in
            make.top.equalTo(passwordTextField!.snp.bottom).offset(7)
            make.height.equalTo(20)
            make.width.greaterThanOrEqualTo(60)
            make.right.equalTo(passwordTextField!)
        })
        
        loginButton = CommonButton(title: R.string.localizable.log_in()).addTo(superView: shadowContainView).configure({ (button) in
//            button.addTarget(self, action: #selector(), for: .touchUpInside)
        }).layout(snapKitMaker: { (make) in
            make.size.equalTo(CGSize(width: 212, height: 42))
            make.top.equalTo(mailButton!.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        })
        
        twitterButton = UIButton().addTo(superView: containView).configure { (button) in
            button.setImage(R.image.setting_Twitter(), for: .normal)
            button.titleLabel?.font = UIFont.size11
            button.setTitleColor(R.clr.appColor._844501(), for: .normal)
            button.setTitle("Twitter", for: .normal)
        }.layout { (make) in
            make.top.equalTo(shadowContainView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        facebookButton = UIButton().addTo(superView: containView).configure { (button) in
            button.setImage(R.image.setting_Facebook(), for: .normal)
            button.titleLabel?.font = UIFont.size11
            button.setTitleColor(R.clr.appColor._844501(), for: .normal)
            button.setTitle("Facebook", for: .normal)
        }.layout { (make) in
            make.top.equalTo(shadowContainView.snp.bottom).offset(20)
            make.centerX.equalToSuperview().multipliedBy(0.4)
        }
        
        googleButton = UIButton().addTo(superView: containView).configure { (button) in
            button.setImage(R.image.setting_Google(), for: .normal)
            button.titleLabel?.font = UIFont.size11
            button.setTitleColor(R.clr.appColor._844501(), for: .normal)
            button.setTitle("Google+", for: .normal)
        }.layout { (make) in
            make.top.equalTo(shadowContainView.snp.bottom).offset(20)
            make.centerX.equalToSuperview().multipliedBy(1.6)
        }
        
        containView.layout { (make) in
            make.bottom.equalTo(twitterButton!.snp.bottom).offset(20)
        }
        
        addCloseButton(layout: { (make) in
            make.size.equalTo(closeButtonSize)
            make.top.equalTo(containView)
            make.left.equalTo(containView.snp.right).offset(5)
        }) { _ in
            TransitionManager.dismiss(animated: true)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        twitterButton?.centerVertically(padding: 5)
        facebookButton?.centerVertically(padding: 5)
        googleButton?.centerVertically(padding: 5)
    }
}
