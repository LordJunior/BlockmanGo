//
//  LaunchViewController.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/16.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit
class LaunchViewController: UIViewController {
    
    /// 这个属性用于判断是否是 正常启动显示这个界面
    var isDisplayingForNormalLaunch: Bool = true
    
    /// 这个属性用于判断是否是 验证失败时，跳到这个界面
    var isDisplayingForAuthorizationExpired: Bool = false

    private weak var checkForUpdateController: CheckForUpdatesViewController?
    private weak var backgroundImageView: GravityImageView?
    private weak var skyInfiniteView: LaunchInfiniteTranslationSkyView?
    private weak var logoImageView: UIImageView?
    private weak var leftCloudImageView: UIImageView?
    private weak var rightCloudImageView: UIImageView?
    private weak var joinGameButton: UIButton?
    private weak var bulletinButton: UIButton?
    private weak var loginButton: UIButton?
    
    private var shouldResignBeforeEnterGame = false // 如果该值为真，那么就必须登录完才能进游戏
    
    deinit {
        DebugLog("LaunchViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageView = GravityImageView(image: R.image.launch_background()).addTo(superView: view).layout { (make) in
            make.edges.equalToSuperview()
        }.configure { (imageView) in
            imageView.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
        }
        
        skyInfiniteView = LaunchInfiniteTranslationSkyView().addTo(superView: view).layout(snapKitMaker: { (make) in
            make.edges.equalToSuperview()
        })
        
        let suspendButtonConfig = { (button: AdjustLayoutButton) in
            button.titleLabel?.font = UIFont.size11
            button.titleLabel?.textAlignment = .center
            button.setTitleColor(UIColor.white, for: .normal)
            button.transform = CGAffineTransform.init(translationX: 50, y: 0)
            button.contentLayout = .imageTopTitleBottom
        }
        
//        bulletinButton = AdjustLayoutButton().addTo(superView: view).configure({ (button) in
//            button.setImage(R.image.launch_bulletin(), for: .normal)
//            button.setTitle(R.string.localizable.bulletion(), for: .normal)
//            button.addTarget(self, action: #selector(bulletinButtonClicked), for: .touchUpInside)
//        }).configure(suspendButtonConfig).layout(snapKitMaker: { (make) in
//            make.size.equalTo(CGSize(width: 50, height: 46))
//            make.top.equalToSuperview().offset(15)
//            make.right.equalToSuperview().inset(8)
//        })
        
        loginButton = AdjustLayoutButton().addTo(superView: view).configure({ (button) in
            button.setImage(R.image.setting_login(), for: .normal)
            button.setTitle(R.string.localizable.log_in(), for: .normal)
            button.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        }).configure(suspendButtonConfig).layout(snapKitMaker: { (make) in
            make.size.right.equalTo(CGSize(width: 50, height: 46))
//            make.top.equalTo(bulletinButton!.snp.bottom).offset(12)
            make.top.equalToSuperview().offset(15)
        })
        
        logoImageView = UIImageView(image: R.image.launch_logo()).addTo(superView: view).layout { (make) in
            make.center.equalToSuperview()
        }.configure { (imageView) in
            imageView.alpha = 0.0
            imageView.transform = CGAffineTransform.init(translationX: 0, y: -self.view.height * 0.5)
        }
        
        leftCloudImageView = UIImageView(image: R.image.launch_cloud_left()).addTo(superView: view).layout { (make) in
            make.left.bottom.equalToSuperview()
        }.configure { (imageView) in
            imageView.transform = CGAffineTransform.init(translationX: -imageView.width, y: 0)
        }
        
        rightCloudImageView = UIImageView(image: R.image.launch_cloud_right()).addTo(superView: view).layout { (make) in
            make.right.bottom.equalToSuperview()
        }.configure { (imageView) in
            imageView.transform = CGAffineTransform.init(translationX: imageView.width, y: 0)
        }
        
        joinGameButton = UIButton().addTo(superView: view).layout { (make) in
            make.bottom.equalToSuperview().inset(25)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.45)
            make.height.equalTo(40)
        }.configure { (button) in
            button.setBackgroundImage(R.image.launch_join_background(), for: .normal)
            button.setTitle(R.string.localizable.click_enter_game(), for: .normal)
            button.titleLabel?.font = UIFont.boldSize16
            button.setTitleColor(UIColor.white, for: .normal)
            button.isHidden = true
            button.addTarget(self, action: #selector(joinGameButtonClicked), for: .touchUpInside)
        }

        guard isDisplayingForNormalLaunch else {
            triggerAnimation()
            self.shouldResignBeforeEnterGame = isDisplayingForAuthorizationExpired
            TransitionManager.presentInNormalTransition(LoginViewController.self, parameter: (isDisplayingForAuthorizationExpired, self))
            return
        }
        /// 正常的打开APP流程
        /// add检查更新控制器
        let checkUpdateController = CheckForUpdatesViewController()
        checkUpdateController.delegate = self
        addChildViewController(checkUpdateController)
        checkUpdateController.view.addTo(superView: view).layout { (make) in
            make.edges.equalToSuperview()
        }
        checkUpdateController.didMove(toParentViewController: self)
        checkForUpdateController = checkUpdateController
        
        checkUpdateController.startCheckForUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AnalysisService.trackEvent(.enter_blockmango_page)
    }
    
    private func removeCheckForUpdateController() {
        checkForUpdateController?.willMove(toParentViewController: nil)
        checkForUpdateController?.view.removeFromSuperview()
        checkForUpdateController?.removeFromParentViewController()
        checkForUpdateController = nil
    }
    
    private func triggerAnimation() {
        skyInfiniteView?.startTranslating()
        
        UIView.animate(withDuration: 0.5, delay: 0.8, options: .curveEaseOut, animations: {
            self.bulletinButton?.transform = CGAffineTransform.identity
            self.loginButton?.transform = CGAffineTransform.identity
        })
        
        UIView.animate(withDuration: 0.8, delay: 0.5, options: .curveEaseOut, animations: {
            self.backgroundImageView?.transform = CGAffineTransform.identity
            self.logoImageView?.alpha = 1.0
            self.logoImageView?.transform = CGAffineTransform.identity
            self.leftCloudImageView?.transform = CGAffineTransform.identity
            self.rightCloudImageView?.transform = CGAffineTransform.identity
        }, completion: { (finished) in
            self.joinGameButton?.isHidden = false
            self.joinGameButton?.makeBreathAnimation(duration: 1)
            self.backgroundImageView?.startGravityMotion()
//            delay(0.75, exeute: {
//                self.bulletinButtonClicked()
//            })
        })
    }
    
    @objc private func joinGameButtonClicked() {
        guard !shouldResignBeforeEnterGame else {
            TransitionManager.presentInNormalTransition(LoginViewController.self, parameter: (true, self))
            return
        }
        skyInfiniteView?.stopTranslating()
        backgroundImageView?.stopGravityMotion()
        DecorationControllerManager.shared.removeFromParent()
        AnalysisService.trackEvent(.click_entergame)
        TransitionManager.currentNavigationController()?.setViewControllers([HomePageViewController()], animated: false)
    }
    
    @objc private func bulletinButtonClicked() {
        TransitionManager.presentInNormalTransition(BulletinViewController.self, parameter: self)
    }
    
    @objc private func loginButtonClicked() {
        TransitionManager.presentInNormalTransition(SwitchAccountViewController.self)
    }
    
    private func checkAuthorization() {
        LaunchModuleManager.generateNewAuthorizationIfNeed {[unowned self] (result) in
            switch result {
            case .success(_):
                break
            case .failure(.userNotBindDevice):
                self.shouldResignBeforeEnterGame = true
                TransitionManager.presentInNormalTransition(LoginViewController.self, parameter: (true, self))
            default:
                self.shouldResignBeforeEnterGame = true
                break
            }
        }
    }
}

extension LaunchViewController: CheckForUpdatesViewControllerDelegate {
    func checkForUpdatesDidFinished() {
        checkAuthorization()
        removeCheckForUpdateController()
        // 先提前创建好装饰view
        DecorationControllerManager.shared.add(toParent: self, layout: { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }) {
            DecorationControllerManager.shared.suspendRendering()
        }
        triggerAnimation()
    }
}

extension LaunchViewController: BulletinViewControllerDelegate {
    func bulletinViewControllerDoneButtonDidClicked(_ viewController: BulletinViewController) {
        TransitionManager.dismiss(animated: true)
    }
}

extension LaunchViewController: LoginViewControllerDelegate {
    func loginViewControllerDidCancel(_ viewController: LoginViewController) {
        TransitionManager.dismiss(animated: true)
    }
    
    func loginViewControllerDidLoginSuccessful(_ viewController: LoginViewController) {
        TransitionManager.dismiss(animated: true)
        shouldResignBeforeEnterGame = false
        joinGameButtonClicked()
    }
}
