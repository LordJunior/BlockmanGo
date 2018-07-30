//
//  LaunchViewController.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/16.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit
class LaunchViewController: UIViewController {

    private weak var checkForUpdateController: CheckForUpdatesViewController?
    private weak var backgroundImageView: UIImageView?
    private weak var skyInfiniteView: LaunchInfiniteTranslationSkyView?
    private weak var logoImageView: UIImageView?
    private weak var leftCloudImageView: UIImageView?
    private weak var rightCloudImageView: UIImageView?
    private weak var joinGameButton: UIButton?
    private weak var bulletinButton: UIButton?
    
    private let launchManager = LaunchModelManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundImageView = UIImageView(image: R.image.launch_background()).addTo(superView: view).layout { (make) in
            make.edges.equalToSuperview()
        }.configure { (imageView) in
            imageView.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
        }
        
        skyInfiniteView = LaunchInfiniteTranslationSkyView().addTo(superView: view).layout(snapKitMaker: { (make) in
            make.edges.equalToSuperview()
        })
        
        bulletinButton = UIButton().addTo(superView: view).layout(snapKitMaker: { (make) in
            make.size.equalTo(CGSize(width: 30, height: 44))
            make.top.equalToSuperview()
            make.right.equalToSuperview().inset(10)
        }).configure({ (button) in
            button.setImage(R.image.launch_bulletin(), for: .normal)
            button.titleLabel?.font = UIFont.size11
            button.setTitleColor(UIColor.white, for: .normal)
            button.setTitle("公告", for: .normal)
            button.transform = CGAffineTransform.init(translationX: 0, y: -44)
            button.addTarget(self, action: #selector(bulletinButtonClicked), for: .touchUpInside)
            button.centerVertically()
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
            make.top.equalTo(logoImageView!.snp.bottom).offset(65)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.45)
            make.height.equalTo(40)
        }.configure { (button) in
            button.setBackgroundImage(R.image.launch_join_background(), for: .normal)
            button.setTitle("点击进入游戏", for: .normal)
            button.titleLabel?.font = UIFont.boldSize16
            button.setTitleColor(UIColor.white, for: .normal)
            button.isHidden = true
            button.addTarget(self, action: #selector(joinGameButtonClicked), for: .touchUpInside)
        }

        /// add检查更新控制器
        let checkUpdateController = CheckForUpdatesViewController()
        checkUpdateController.delegate = self
        addChildViewController(checkUpdateController)
        checkUpdateController.view.addTo(superView: view).layout { (make) in
            make.edges.equalToSuperview()
        }
        checkUpdateController.didMove(toParentViewController: self)
        checkForUpdateController = checkUpdateController
        
        /// 创建一个新账号
        launchManager.generateNewAccount()
    }
    
    private func removeCheckForUpdateController() {
        checkForUpdateController?.willMove(toParentViewController: nil)
        checkForUpdateController?.view.removeFromSuperview()
    }
    
    private func triggerAnimation() {
        skyInfiniteView?.startTranslating()
        
        UIView.animate(withDuration: 0.5, delay: 0.8, options: .curveEaseOut, animations: {
            self.bulletinButton?.transform = CGAffineTransform.identity
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
            delay(0.75, exeute: {
                self.bulletinButtonClicked()
            })
        })
    }
    
    @objc private func joinGameButtonClicked() {
        skyInfiniteView?.stopTranslating()
        DecorationControllerManager.shared.removeFromParent()
        TransitionManager.currentNavigationController()?.setViewControllers([HomePageViewController()], animated: false)
    }
    
    @objc private func bulletinButtonClicked() {
        TransitionManager.present(BulletinViewController.self, animated: false, parameter: self, completion: nil)
    }
}

extension LaunchViewController: CheckForUpdatesViewControllerDelegate {
    func checkForUpdatesDidFinished() {
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
        TransitionManager.dismiss(animated: false, completion: nil)
    }
}

