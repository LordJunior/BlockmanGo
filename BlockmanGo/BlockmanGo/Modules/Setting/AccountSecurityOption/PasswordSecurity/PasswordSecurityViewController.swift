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
        })
        
        let random = arc4random() % 100
        if random > 50 { // 已设置过密码，更新密码
            originPasswordTextField?.placeholder = "输入旧密码"
            newPasswordTextField?.placeholder = "输入新密码"
            operationButton?.setTitle("确认修改", for: .normal)
            confirmPasswordTextField = CommonTextField(placeHolder: "重复新密码").addTo(superView: view).layout(snapKitMaker: { (make) in
                make.size.centerX.equalTo(newPasswordTextField!)
                make.top.equalTo(newPasswordTextField!.snp.bottom).offset(5)
            })
        }
    }

}
