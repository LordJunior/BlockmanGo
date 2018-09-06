//
//  ThirdLoginSecurityViewController.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/8/23.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit
import GoogleSignIn

class ThirdSignSecurityViewController: UIViewController {

    private let platforms: [LoginPlatformEnum] = [.facebook, .google]
    private let googleSignInService = GoogleSignService()
    private var facebookSignInService: FacebookSignService?
    
    private weak var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        googleSignInService.delegate = self
        googleSignInService.uiDelegate = self
        
        facebookSignInService = FacebookSignService(from: self)
        facebookSignInService?.delegate = self
        
        view.backgroundColor = R.clr.appColor._eed5a0()
        view.layer.cornerRadius = 12
        
        tableView = UITableView().addTo(superView: view).configure { (tableView) in
            tableView.separatorStyle = .none
            tableView.backgroundColor = UIColor.clear
            tableView.bounces = false
            tableView.register(cellForClass: ThirdSignSecurityOptionTableViewCell.self)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.rowHeight = 45
            tableView.sectionHeaderHeight = 5
            tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0)
        }.layout { (make) in
            make.edges.equalToSuperview()
        }
        
        UILabel().addTo(superView: view).configure { (label) in
            label.textColor = R.clr.appColor._a36b2e()
            label.font = UIFont.size11
            label.text = "绑定以后，你可以使用快捷登录"
        }.layout { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    private func bindThirdLogin(platform: LoginPlatformEnum) {
        BlockHUD.showLoading(inView: view)
        switch platform {
        case .google:
            googleSignInService.signIn()
        default:
            facebookSignInService?.signIn()
        }
    }
    
    private func bindThirdSign(openID: String, token: String, platform: LoginPlatformEnum) {
        ThirdSignSecurityModuleManager.bindThirdLogin(openID: openID, token: token, platform: platform, completion: { (result) in
            BlockHUD.hide(forView: self.view)
            switch result {
            case .success(_):
                AlertController.alert(title: "绑定成功", message: nil, from: self)
                self.tableView?.reloadData() // 刷新界面
            case .failure(.thirdPartAccountAlreadyBindUser):
                AlertController.alert(title: "该\(platform.rawValue)账号已经绑定过其他游戏账号", message: nil, from: self)
            case .failure(let error):
                self.defaultParseError(error)
            }
        })
    }
    
    private func unbindThirdLogin() {
        ThirdSignSecurityModuleManager.unbindThirdLogin { (result) in
            BlockHUD.hide(forView: self.view)
            switch result {
            case .success(_):
                AlertController.alert(title: "解绑成功", message: nil, from: self)
                self.tableView?.reloadData() // 刷新界面
            case .failure(let error):
                self.defaultParseError(error)
            }
        }
    }
}

extension ThirdSignSecurityViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return platforms.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ThirdSignSecurityOptionTableViewCell
        let platform = platforms[indexPath.section]
        cell.platform = platform
        cell.isBinding = UserManager.shared.loginPlatform == platform
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let optionCell = tableView.cellForRow(at: indexPath) as? ThirdSignSecurityOptionTableViewCell else {
            return
        }
        if optionCell.isBinding {
            AlertController.alert(title: "是否解除当前绑定?", message: nil, from: self, showCancelButton: true)?.done(completion: { _ in
                self.unbindThirdLogin()
            })
        }else if UserManager.shared.loginPlatform == .app { // 当前账号未绑定第三方
            AlertController.alert(title: "是否绑定?", message: "绑定以后，您可用于快捷登录", from: self, showCancelButton: true)?.done(completion: { _ in
                self.bindThirdLogin(platform: optionCell.platform)
            })
        }else { // 当前账号已绑定过其他第三方
            AlertController.alert(title: "请先解除原有的绑定", message: nil, from: self)
        }
    }
}

extension ThirdSignSecurityViewController: GoogleSignServiceDelegate, GoogleSignServiceUIDelegate {
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
        bindThirdSign(openID: openID, token: token, platform: .google)
    }
    
    func signDidCanceled(_ signIn: GoogleSignService) {
        BlockHUD.hide(forView: self.view)
    }
    
    func sign(_ signIn: GoogleSignService, didSignFailed: Error) {
        BlockHUD.hide(forView: self.view)
        AlertController.alert(title: "绑定失败，请重试", message: nil, from: self)
    }
}

extension ThirdSignSecurityViewController: FacebookSignServiceDelegate {
    func signDidCanceled(_ signIn: FacebookSignService) {
        BlockHUD.hide(forView: self.view)
    }
    
    func sign(_ signIn: FacebookSignService, didSignFor openID: String, token: String) {
        bindThirdSign(openID: openID, token: token, platform: .facebook)
    }
    
    func sign(_ signIn: FacebookSignService, didSignFailed: Error) {
        BlockHUD.hide(forView: self.view)
        AlertController.alert(title: "绑定失败，请重试", message: nil, from: self)
    }
}
