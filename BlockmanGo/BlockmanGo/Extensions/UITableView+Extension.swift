//
//  UITableView+Extension.swift
//  BlockyModes
//
//  Created by KiBen Hung on 2018/1/7.
//  Copyright © 2018年 SandboxOL. All rights reserved.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(cellForClass cell: T.Type) {
        register(cell, forCellReuseIdentifier: cell.reuseIdentifier)
    }
    
    func register<T: UITableViewCell>(cellForNib cell: T.Type) {
        let nib = UINib(nibName: cell.reuseIdentifier, bundle: nil)
        register(nib, forCellReuseIdentifier: cell.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Can not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}
