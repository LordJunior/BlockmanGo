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
        
        let nicknameTextSize = (UserManager.shared.nickname as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : UIFont.size14], context: nil).size
        AccountInfoView().addTo(superView: view).layout { (make) in
            make.top.left.equalToSuperview().inset(5)
            make.size.equalTo(CGSize(width: nicknameTextSize.width + 80, height: 53))
        }.configure { (infoView) in
            infoView.nickname = UserManager.shared.nickname
            infoView.userID = UserManager.shared.userID
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
    
    @objc private func playButtonClicked(sender: UIButton) {
        TransitionManager.pushViewController(GameViewController.self, animated: false)
    }
}

