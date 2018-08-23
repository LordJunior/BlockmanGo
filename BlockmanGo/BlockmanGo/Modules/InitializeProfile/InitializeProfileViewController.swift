//
//  InitializeProfileViewController.swift
//  BlockmanGo
//
//  Created by KiBen Hung on 2018/7/20.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit
import SnapKit

class InitializeProfileViewController: UIViewController {

    private weak var selectedGenderButton: UIButton?
    private weak var randomInputView: RandomInputView?
    private var transparentContainViewCenterYToSuperConstraint: Constraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        let transparentContainView = UIView().addTo(superView: view).configure { (view) in
            view.backgroundColor = UIColor.clear
        }.layout { (make) in
            make.size.equalTo(CGSize(width: 270, height: 305))
            transparentContainViewCenterYToSuperConstraint = make.centerY.equalToSuperview().constraint
            make.centerX.equalToSuperview()
        }
        
        let nameTipsView = UIButton().addTo(superView: transparentContainView).layout { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
        }.configure { (button) in
            button.setBackgroundImage(R.image.profile_name_tips(), for: .normal)
            button.isUserInteractionEnabled = false
            button.titleLabel?.font = UIFont.size12
            button.setTitleColor(R.clr.appColor._844501(), for: .normal)
            button.setTitle("你已经成功登录，输入一个昵称吧", for: .normal)
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        }
        
        let profileContainView = UIImageView(image: R.image.general_alert_background()).addTo(superView: transparentContainView).layout { (make) in
            make.top.equalTo(nameTipsView.snp.bottom).offset(5)
            make.left.right.bottom.equalToSuperview()
        }.configure { (containView) in
            containView.isUserInteractionEnabled = true
        }
        
        let inputNameLabel = UILabel().addTo(superView: profileContainView).configure { (label) in
            label.font = UIFont.size13
            label.textColor = R.clr.appColor._91660b()
            label.text = "输入昵称:"
        }.layout { (make) in
            make.left.equalToSuperview().offset(30)
            make.top.equalToSuperview().offset(20)
        }
        
        randomInputView = RandomInputView().addTo(superView: profileContainView).configure { (inputView) in
            inputView.placeholder = "输入昵称"
            inputView.delegate = self
            inputView.dataSource = self
        }.layout { (make) in
            make.left.right.equalToSuperview().inset(30)
            make.top.equalTo(inputNameLabel.snp.bottom).offset(5)
            make.height.equalTo(40)
        }
        
        let nicknameGuidelineLabel = UILabel().addTo(superView: profileContainView).configure { (label) in
            label.font = UIFont.size10
            label.textColor = R.clr.appColor._b17f63()
            label.text = "仅限6个字母以内"
        }.layout { (make) in
            make.left.right.equalToSuperview().offset(35)
            make.top.equalTo(randomInputView!.snp.bottom).offset(3)
        }
        
        let switchGenderLabel = UILabel().addTo(superView: profileContainView).configure { (label) in
            label.font = UIFont.size13
            label.textColor = R.clr.appColor._91660b()
            label.text = "选择性别:"
            }.layout { (make) in
            make.left.equalToSuperview().offset(30)
            make.top.equalTo(nicknameGuidelineLabel.snp.bottom).offset(15)
        }
        
        let maleOptionButton = GenderButton(gender: .male).addTo(superView: profileContainView).configure { (button) in
            button.tag = Gender.male.rawValue
            button.isSelected = true
            selectedGenderButton = button
            button.addTarget(self, action: #selector(switchGender(_:)), for: .touchUpInside)
        }.layout { (make) in
            make.left.equalToSuperview().offset(30)
            make.top.equalTo(switchGenderLabel.snp.bottom).offset(5)
            make.size.equalTo(CGSize(width: 100, height: 40))
        }
        
        let femaleOptionButton = GenderButton(gender: .female).addTo(superView: profileContainView).configure { (button) in
            button.tag = Gender.female.rawValue
            button.addTarget(self, action: #selector(switchGender(_:)), for: .touchUpInside)
        }.layout { (make) in
            make.right.equalToSuperview().inset(30)
            make.top.height.width.equalTo(maleOptionButton)
        }
        
        UIButton().addTo(superView: profileContainView).configure { (button) in
            button.setBackgroundImage(R.image.general_button_background_selected(), for: .normal)
            button.titleLabel?.font = UIFont.size14
            button.setTitleColor(R.clr.appColor._844501(), for: .normal)
            button.setTitle("开始游戏", for: .normal)
            button.titleEdgeInsets = UIEdgeInsetsMake(-2, 0, 0, 0)
            button.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
        }.layout { (make) in
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(42)
            make.top.equalTo(femaleOptionButton.snp.bottom).offset(15)
        }
    }
    
    @objc private func startButtonClicked() {
        TransitionManager.dismiss(animated: false)
    }
    
    @objc private func switchGender(_ sender: GenderButton) {
        sender.isSelected = true
        selectedGenderButton?.isSelected = false
        selectedGenderButton = sender
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let _ = randomInputView?.resignFirstResponder()
    }
}

extension InitializeProfileViewController: RandomInputViewDelegate, RandomInputViewDataSource {
    func randomInputTextForRandoming(_ randomInputView: RandomInputView) -> String? {
        return String(arc4random() % 99999)
    }
    
    func randomInputViewDidBeginInputting(_ randomInputView: RandomInputView) {
        transparentContainViewCenterYToSuperConstraint?.update(offset: -50)
        UIView.animate(withDuration: 0.35) {
            self.view.layoutIfNeeded()
        }
    }
    
    func randomInputViewDidEndInputting(_ randomInputView: RandomInputView) {
        transparentContainViewCenterYToSuperConstraint?.update(offset: 0)
        UIView.animate(withDuration: 0.35) {
            self.view.layoutIfNeeded()
        }
    }
}
