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
    private let optionTitles = [R.string.localizable.switch_account(), R.string.localizable.account_and_security(), R.string.localizable.about_me(), R.string.localizable.clear_cache()]
    
    deinit {
        DebugLog("SettingViewController Deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        let backgroundView = UIImageView(image: R.image.general_alert_background()).addTo(superView: view).layout { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 296, height: 240))
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
            TransitionManager.dismiss(animated: true)
            if UserManager.shared.passwordIfHave() {
                PrepareLauncher.resetRootViewControllerToLaunch(isAuthorizationExpired: false)
//                TransitionManager.presentInHidePresentingTransition(LoginViewController.self, parameter: (false, self))
            }else {
                TransitionManager.dismiss(animated: true)
                AlertController.alert(title: R.string.localizable.not_set_password_switch_will_lost(), message: nil, from: TransitionManager.rootViewController, showCancelButton: true)?.setCancelTitle(R.string.localizable.dont_want_it()).setDoneTitle(R.string.localizable.set_password()).done(completion: { (_) in
                    TransitionManager.presentInNormalTransition(AccountSecurityOptionViewController.self)
                }).cancel(completion: { _ in
                    PrepareLauncher.resetRootViewControllerToLaunch()
//                    TransitionManager.presentInHidePresentingTransition(LoginViewController.self, parameter: (false, self))
                })
            }
        case 1:
            TransitionManager.presentInHidePresentingTransition(AccountSecurityOptionViewController.self)
        case 2:
            TransitionManager.presentInHidePresentingTransition(AboutUsViewController.self)
        case 3:
            TransitionManager.presentInHidePresentingTransition(ClearCacheViewController.self)
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
        TransitionManager.dismissToRootViewController(animated: true)
    }
}
