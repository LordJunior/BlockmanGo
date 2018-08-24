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
}
