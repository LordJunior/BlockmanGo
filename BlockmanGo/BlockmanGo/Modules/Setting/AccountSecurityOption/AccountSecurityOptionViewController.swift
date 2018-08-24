//
//  AccountSecurityOptionViewController.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/8/23.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit

class AccountSecurityOptionViewController: UIViewController {

    private let accountSecurityOptionTitles = ["设置密码", "邮箱绑定", "第三方绑定"]
    private weak var tableView: UITableView?
    private weak var passwordIfSetLabel: UILabel?
    private weak var passwordSecurityController: PasswordSecurityViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        let optionContainView = UIImageView(image: R.image.general_alert_background()).addTo(superView: view).layout { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().multipliedBy(0.5)
            make.size.equalTo(CGSize(width: 140, height: 300))
        }.configure { (imageView) in
            imageView.isUserInteractionEnabled = true
        }
        
        tableView = UITableView().addTo(superView: optionContainView).configure { (tableView) in
            tableView.separatorStyle = .none
            tableView.backgroundColor = UIColor.clear
            tableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0)
            tableView.bounces = false
            tableView.register(cellForClass: AccountSecurityOptionTableViewCell.self)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.rowHeight = 45
            tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: UITableViewScrollPosition.none)
        }.layout { (make) in
            make.edges.equalToSuperview()
        }
        
        let securityContentView = UIImageView(image: R.image.general_alert_background()).addTo(superView: view).layout { (make) in
            make.centerY.equalTo(optionContainView)
            make.size.equalTo(CGSize(width: 310, height: 300))
            make.left.equalTo(optionContainView.snp.right)
        }.configure { (imageView) in
            imageView.isUserInteractionEnabled = true
        }
        
        passwordIfSetLabel = UILabel().addTo(superView: securityContentView).configure({ (label) in
            label.font = UIFont.size13
            label.textColor = R.clr.appColor._844501()
            label.text = "当前ID: 12456266"
        }).layout(snapKitMaker: { (make) in
            make.left.top.equalToSuperview().offset(20)
        })
        
        addCloseButton(layout: { (make) in
            make.left.equalTo(securityContentView.snp.right).offset(5)
            make.top.equalTo(securityContentView)
            make.size.equalTo(closeButtonSize)
        }) { _ in
            TransitionManager.dismiss(animated: true)
        }
        
        let passwordSecurityController = PasswordSecurityViewController()
        addChildViewController(passwordSecurityController)
        passwordSecurityController.view.addTo(superView: securityContentView).layout { (make) in
            make.top.equalTo(passwordIfSetLabel!.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
        passwordSecurityController.didMove(toParentViewController: self)
        self.passwordSecurityController = passwordSecurityController
    }
}

extension AccountSecurityOptionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountSecurityOptionTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AccountSecurityOptionTableViewCell
        cell.optionTitle = accountSecurityOptionTitles[indexPath.row]
        return cell
    }
}