//
//  GameModesView.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/11.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit

protocol GameModesViewDelegate: class {
    func gameModesView(_ modesView: GameModesView, didSelectModeAt index: Int)
}

class GameModesView: UIView {

    weak var delegate: GameModesViewDelegate?
    
    private let modeTitles = [R.string.localizable.category_all(), R.string.localizable.category_pvp(), /*R.string.localizable.category_manage(),*/ R.string.localizable.category_adventure(), /*R.string.localizable.category_gun()*/]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        UIImageView(image: R.image.game_mode_background()).addTo(superView: self).layout { (make) in
            make.left.top.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(16)
        }
        
        UITableView().addTo(superView: self).configure { (tableView) in
            tableView.register(cellForClass: GameModesTableCell.self)
            tableView.separatorStyle = .none
            tableView.bounces = false
            tableView.dataSource = self
            tableView.delegate = self
            tableView.backgroundColor = UIColor.clear
            tableView.rowHeight = 49
            tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
        }.layout { (make) in
            make.left.equalToSuperview().offset(18)
            make.top.equalToSuperview().offset(55)
            make.right.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension GameModesView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modeTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let modeCell = tableView.dequeueReusableCell(forIndexPath: indexPath) as GameModesTableCell
        modeCell.modeTitle = modeTitles[indexPath.row]
        return modeCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.x = -tableView.width
        UIView.animate(withDuration: 0.25, delay: Double(indexPath.row) * 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: {
            cell.x = 0
        }, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.gameModesView(self, didSelectModeAt: indexPath.row)
    }
}
