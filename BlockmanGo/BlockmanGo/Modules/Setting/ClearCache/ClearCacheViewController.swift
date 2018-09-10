//
//  ClearCacheViewController.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/9/6.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit

class ClearCacheViewController: UIViewController {
    
    private weak var tableView: UITableView?
    private let optionTitles = ["图片缓存 (0.0M)", "地图缓存 (0.0M)"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        let backgroundView = UIImageView(image: R.image.general_alert_background()).addTo(superView: view).layout { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 296, height: 150))
        }.configure { (imageView) in
            imageView.isUserInteractionEnabled = true
        }
        
        tableView = UITableView().addTo(superView: backgroundView).configure { (tableView) in
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
            make.left.equalTo(backgroundView.snp.right).offset(10)
            make.top.equalTo(backgroundView).offset(-5)
            make.size.equalTo(closeButtonSize)
        }) { _ in
            TransitionManager.dismiss(animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ClearCacheModuleManager.calculateImageCacheSize { (sizeText) in
            guard let cell = self.tableView?.cellForRow(at: IndexPath(row: 0, section: 0)) as? SettingOptionTableViewCell else {
                return
            }
            cell.optionTitle = "图片缓存" + " (" + sizeText + ")"
        }
        
        ClearCacheModuleManager.calculateMapCacheSize { (sizeText) in
            guard let cell = self.tableView?.cellForRow(at: IndexPath(row: 0, section: 1)) as? SettingOptionTableViewCell else {
                return
            }
            cell.optionTitle = "地图缓存" + " (" + sizeText + ")"
        }
    }
}

extension ClearCacheViewController: UITableViewDataSource, UITableViewDelegate {
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
        tableView.deselectRow(at: indexPath, animated: false)
        BlockHUD.showLoading(inView: view)
        switch indexPath.section {
        case 0:
            ClearCacheModuleManager.clearImageCache {
                BlockHUD.hide(forView: self.view)
                (tableView.cellForRow(at: indexPath) as! SettingOptionTableViewCell).optionTitle = self.optionTitles[0]
            }
        case 1:
            ClearCacheModuleManager.clearMapCache {
                BlockHUD.hide(forView: self.view)
                (tableView.cellForRow(at: indexPath) as! SettingOptionTableViewCell).optionTitle = self.optionTitles[1]
            }
        default:
            break
        }
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
