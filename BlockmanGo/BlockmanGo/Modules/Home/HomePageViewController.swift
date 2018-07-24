//
//  ViewController.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/4.
//  Copyright © 2018年 Ben. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DecorationControllerManager.shared.removeFromParent()
        DecorationControllerManager.shared.add(toParent: self, layout: { (make) in
            make.left.right.top.bottom.equalToSuperview()
        })
        
        let accountInfoView = AccountInfoView().addTo(superView: view).layout { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 160, height: 53))
        }
        
        let button = UIButton().addTo(superView: view).configure { (button) in
            button.setBackgroundImage(R.image.home_play(), for: .normal)
            button.addTarget(self, action: #selector(playButtonClicked(sender:)), for: .touchUpInside)
        }.layout { (make) in
            make.size.equalTo(CGSize(width: 200, height: 84))
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(64)
        }
        
        let button1 = UIButton().addTo(superView: view).configure { (button) in
            button.setBackgroundImage(R.image.home_play(), for: .normal)
            button.addTarget(self, action: #selector(changePosition(sender:)), for: .touchUpInside)
            button.setTitle("改变位置", for: .normal)
            }.layout { (make) in
                make.size.equalTo(CGSize(width: 200, height: 84))
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().inset(164)
        }
    }
    
    @objc private func playButtonClicked(sender: UIButton) {
        TransitionManager.pushViewController(GameViewController.self, animated: false)
    }
    
    @objc private func changePosition(sender: UIButton) {
        if sender.isSelected {
            DecorationControllerManager.shared.setPosition(x: 0.6, y: 0.0, z: -0.7)
        }else {
            DecorationControllerManager.shared.setPosition(x: -0.6, y: 0.0, z: -0.7)
        }
        sender.isSelected = !sender.isSelected
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        TransitionManager.present(InitializeProfileViewController.self, animated: false)
    }
}

