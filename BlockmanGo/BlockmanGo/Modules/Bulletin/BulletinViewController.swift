//
//  BulletinViewController.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/18.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit

protocol BulletinViewControllerDelegate: class {
    func bulletinViewControllerDoneButtonDidClicked(_ viewController: BulletinViewController)
}

class BulletinViewController: UIViewController {

    weak var delegate: BulletinViewControllerDelegate?
    
    private let bulletinModelManager = BulletinModelManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = parameter as? BulletinViewControllerDelegate
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        let containView = UIImageView(image: R.image.general_alert_background()).addTo(superView: view).layout { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.55)
            make.height.equalToSuperview().multipliedBy(0.85)
        }.configure { (containView) in
            containView.isUserInteractionEnabled = true
        }
        
        let contentContainView = UIView().addTo(superView: containView).configure { (containView) in
            containView.backgroundColor = R.clr.appColor._eed5a0()
            containView.layer.cornerRadius = 12
            containView.clipsToBounds = true
        }.layout { (make) in
            make.left.right.top.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(72)
        }
        
        let bulletinTitleLabel = UILabel().addTo(superView: contentContainView).configure({ (label) in
            label.textColor = R.clr.appColor._844501()
            label.font = UIFont.boldSize15
            label.text = R.string.localizable.update_bulletin()
        }).layout(snapKitMaker: { (make) in
            make.left.top.equalToSuperview().offset(10)
        })
        
        let bulletinContentTextView = UITextView().addTo(superView: contentContainView).configure({ (textView) in
            textView.isEditable = false
            textView.isSelectable = false
            textView.textAlignment = .left
            textView.backgroundColor = UIColor.clear
        }).layout(snapKitMaker: { (make) in
            make.top.equalTo(bulletinTitleLabel.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview().inset(10)
        })
        
        UIButton().addTo(superView: containView).configure { (button) in
            button.setBackgroundImage(R.image.general_button_background_selected(), for: .normal)
            button.titleLabel?.font = UIFont.boldSize15
            button.setTitleColor(R.clr.appColor._844501(), for: .normal)
            button.setTitle(R.string.localizable.i_know(), for: .normal)
            button.addTarget(self, action: #selector(doneButtonClickCallBack), for: .touchUpInside)
        }.layout { (make) in
            make.top.equalTo(contentContainView.snp.bottom).offset(10)
            make.height.equalTo(42)
            make.width.equalTo(contentContainView).multipliedBy(0.48)
            make.centerX.equalToSuperview()
        }
        
        bulletinModelManager.fetchBulletin { (attributedBulletin) in
            bulletinContentTextView.attributedText = attributedBulletin
        }
    }
    
    @objc private func doneButtonClickCallBack() {
        delegate?.bulletinViewControllerDoneButtonDidClicked(self)
    }
}
