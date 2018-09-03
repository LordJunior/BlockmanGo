//
//  SettingViewController.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/8/22.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    private weak var tableView: UITableView?
    private let optionTitles = ["切换账号", "切换账号与安全", "关于Blockman GO", "清除缓存", "退出游戏"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        let backgroundView = UIImageView(image: R.image.general_alert_background()).addTo(superView: view).layout { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 296, height: 285))
        }.configure { (imageView) in
            imageView.isUserInteractionEnabled = true
        }
        
        tableView = UITableView().addTo(superView: backgroundView).configure { (tableView) in
            tableView.separatorStyle = .none
            tableView.backgroundColor = UIColor.clear
            tableView.bounces = false
            tableView.register(cellForClass: SettingOptionTableViewCell.self)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.rowHeight = 45
        }.layout { (make) in
            make.edges.equalToSuperview()
        }
        
        addCloseButton(layout: { (make) in
            make.left.equalTo(backgroundView.snp.right).offset(10)
            make.top.equalTo(backgroundView).offset(-5)
            make.size.equalTo(closeButtonSize)
        }) { _ in
            TransitionManager.dismiss(animated: true)
        }
    }
}

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return optionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SettingOptionTableViewCell
        cell.optionTitle = optionTitles[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.section {
        case 0:
            if UserManager.shared.passwordIfHave() {
                TransitionManager.presentInHidePresentingTransition(LoginViewController.self, parameter: (false, self))
            }else {
                AlertController.alert(title: "该账号未设置密码，切换会导致当前账号丢失，是否继续？", message: nil, from: self, showCancelButton: true)?.setCancelTitle("我不要了").setDoneTitle("去设置").done(completion: { (_) in
                    TransitionManager.presentInHidePresentingTransition(AccountSecurityOptionViewController.self)
                }).cancel(completion: { _ in
                    TransitionManager.presentInHidePresentingTransition(LoginViewController.self, parameter: (false, self))
                })
            }
        case 1:
            TransitionManager.presentInHidePresentingTransition(AccountSecurityOptionViewController.self)
        case 2:
            TransitionManager.presentInHidePresentingTransition(AboutUsViewController.self)
        default:
            break
        }
    }

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 20
        }
        return 5
    }
}

extension SettingViewController: LoginViewControllerDelegate {
    func loginViewControllerDidCancel(_ viewController: LoginViewController) {
        TransitionManager.dismiss(animated: true)
    }
    
    func loginViewControllerDidLoginSuccessful(_ viewController: LoginViewController) {
        NotificationCenter.post(notification: .refreshAccountInfo)
        TransitionManager.dismiss(animated: true) // 先dismiss LoginViewController
        TransitionManager.dismiss(animated: true) // 再dismiss SettingViewController
    }
}
