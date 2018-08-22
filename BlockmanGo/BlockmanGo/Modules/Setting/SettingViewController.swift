//
//  SettingViewController.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/8/22.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit

class SettingViewController: TemplateViewController {

    private let optionTitles = ["切换账号", "切换账号与安全", "关于Blockman GO", "清除缓存", "退出游戏"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundView = UIImageView(image: R.image.general_alert_background()).addTo(superView: view).layout { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 296, height: 285))
        }.configure { (imageView) in
            imageView.isUserInteractionEnabled = true
        }
        
        let tableView = UITableView().addTo(superView: backgroundView).configure { (tableView) in
            tableView.separatorStyle = .none
            tableView.backgroundColor = UIColor.clear
            tableView.bounces = false
            tableView.register(cellForClass: SettingOptionTableViewCell.self)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.rowHeight = 45
        }.layout { (make) in
            make.edges.equalToSuperview()
        }
        
        addCloseButton(layout: { (make) in
            make.left.equalTo(backgroundView).offset(10)
            make.top.equalTo(backgroundView).offset(-5)
            make.size.equalTo(closeButtonSize)
        }) { _ in
            TransitionManager.dismiss(animated: false)
        }
    }

}

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return optionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SettingOptionTableViewCell
        cell.optionTitle = optionTitles[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        TransitionManager.present(GameDetailViewController.self, animated: false)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 20
        }
        return 5
    }
}
