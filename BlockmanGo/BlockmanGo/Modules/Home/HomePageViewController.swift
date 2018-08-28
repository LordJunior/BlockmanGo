//
//  ViewController.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/4.
//  Copyright © 2018年 Ben. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {
    
    private weak var accountInfoView: AccountInfoView?
    
    private let homePageManager = HomePageModelManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DecorationControllerManager.shared.resumeRendering()
        DecorationControllerManager.shared.add(toParent: self, layout: { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }) {
            DecorationControllerManager.shared.setGender(UserManager.shared.gender.rawValue)
        }
        
        accountInfoView = AccountInfoView().addTo(superView: view).configure { (infoView) in
            infoView.nickname = UserManager.shared.nickname
            infoView.userID = "\(UserManager.shared.userID)"
        }
        refreshAccountInfoViewLayout()
        
        /// 设置按钮
        UIButton().addTo(superView: view).configure { (button) in
            button.setBackgroundImage(R.image.setting(), for: .normal)
            button.addTarget(self, action: #selector(settingButtonClicked(sender:)), for: .touchUpInside)
        }.layout { (make) in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.right.top.equalToSuperview().inset(10)
        }
        
        UIButton().addTo(superView: view).configure { (button) in
            button.setBackgroundImage(R.image.home_play(), for: .normal)
            button.addTarget(self, action: #selector(playButtonClicked(sender:)), for: .touchUpInside)
            button.titleLabel?.font = UIFont.size15
            button.setTitle("Multiplayer", for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.titleEdgeInsets = UIEdgeInsetsMake(17, 0, 0, 0)
        }.layout { (make) in
            make.size.equalTo(CGSize(width: 200, height: 84))
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(64)
        }
        
        homePageManager.fetchUserProfile { [unowned self] (result) in
            switch result {
            case .success(let profile):
                self.accountInfoView?.userID = "\(profile.userID)"
                self.accountInfoView?.nickname = profile.nickname
                self.accountInfoView?.portraitURL = profile.portraitURL
            case .failure(.profileNotExist): // 新用户，完善信息
                TransitionManager.presentInNormalTransition(InitializeProfileViewController.self, parameter: self)
            default:
                break
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        DecorationControllerManager.shared.suspendRendering()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DecorationControllerManager.shared.resumeRendering()
        DecorationControllerManager.shared.add(toParent: self, layout: { (make) in
            make.left.right.top.bottom.equalToSuperview()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AnalysisService.trackEvent(.enter_homepage)
    }
    
    private func refreshAccountInfoViewLayout() {
        let nicknameTextSize = (UserManager.shared.nickname as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : UIFont.size14], context: nil).size
        let idTextSize = ("ID: \(UserManager.shared.userID)" as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : UIFont.size11], context: nil).size
        let accountViewWidth = nicknameTextSize.width > idTextSize.width ? nicknameTextSize.width : idTextSize.width
        accountInfoView?.snp.remakeConstraints({ (make) in
            make.top.left.equalToSuperview().inset(5)
            make.size.equalTo(CGSize(width: accountViewWidth + 80, height: 53))
        })
    }
    
    @objc private func settingButtonClicked(sender: UIButton) {
        TransitionManager.presentInNormalTransition(SettingViewController.self)
    }
    
    @objc private func playButtonClicked(sender: UIButton) {
        AnalysisService.trackEvent(.click_play)
        TransitionManager.pushViewController(GameViewController.self, animated: false)
    }
}

extension HomePageViewController: InitializeProfileViewControllerDelegate {
    func initializeProfileViewControllerDidSwitchGender(_ profileController: InitializeProfileViewController) {
        accountInfoView?.gender = profileController.gender
        DecorationControllerManager.shared.setGender(profileController.gender.rawValue)
    }
    
    func initializeProfileViewControllerDidEndEditingProfile(_ profileController: InitializeProfileViewController) {
        guard let nickname = profileController.nickname, !nickname.isEmpty else {
            AlertController.alert(title: "请填写昵称", message: nil, from: profileController)
            return
        }
        guard HomePageModelManager.verifyNickname(nickname), nickname.toUInt64() == 0 else {
            AlertController.alert(title: "请输入正确的昵称", message: nil, from: profileController)
            return
        }
        homePageManager.initializeProfile(nickname: nickname, gender: profileController.gender) { [unowned self] (result) in
            switch result {
            case .success(let profile):
                self.accountInfoView?.userID = "\(profile.userID)"
                self.accountInfoView?.nickname = profile.nickname
                self.accountInfoView?.portraitURL = profile.portraitURL
                self.refreshAccountInfoViewLayout()
                TransitionManager.dismiss(animated: true)
            case .failure(.nicknameExist): // 昵称存在
                AlertController.alert(title: R.string.localizable.the_nickname_exist(), message: nil, from: profileController)
            default:
                AlertController.alert(title: R.string.localizable.common_request_fail_retry(), message: nil, from: profileController)
            }
        }
    }
}
