//
//  ThirdLoginSecurityViewController.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/8/23.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit

class ThirdLoginSecurityViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = R.clr.appColor._eed5a0()
        view.layer.cornerRadius = 12
        
        UITableView().addTo(superView: view).configure { (tableView) in
            tableView.separatorStyle = .none
            tableView.backgroundColor = UIColor.clear
            tableView.bounces = false
            tableView.register(cellForClass: ThirdLoginSecurityOptionTableViewCell.self)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.rowHeight = 45
            tableView.sectionHeaderHeight = 5
            tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0)
        }.layout { (make) in
            make.edges.equalToSuperview()
        }
        
        UILabel().addTo(superView: view).configure { (label) in
            label.textColor = R.clr.appColor._a36b2e()
            label.font = UIFont.size11
            label.text = "绑定以后，你可以使用快捷登录"
        }.layout { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    private func bindThirdLogin() {
        let login = FBSDKLoginManager()
        login.logIn(withReadPermissions: ["public_profile"], from: self) { (result, error) in
            guard error == nil, let result = result else { return }
            print("facebook userID: \(result.token.userID)  token: \(result.token.tokenString)")
        }
    }
    
    private func unbindThirdLogin() {
        
    }
}

extension ThirdLoginSecurityViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ThirdLoginSecurityOptionTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let optionCell = tableView.cellForRow(at: indexPath) as? ThirdLoginSecurityOptionTableViewCell else {
            return
        }
        if optionCell.isBinding {
            AlertController.alert(title: "是否解除当前绑定?", message: nil, from: self, showCancelButton: true)?.done(completion: { _ in
                self.unbindThirdLogin()
            })
        }else {
            AlertController.alert(title: "是否绑定?", message: "绑定以后，您可用于快捷登录", from: self, showCancelButton: true)?.done(completion: { _ in
                self.bindThirdLogin()
            })
        }
    }
}
