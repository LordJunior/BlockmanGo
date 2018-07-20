//
//  Reusable.swift
//  BlockyModes
//
//  Created by KiBen Hung on 2018/1/7.
//  Copyright © 2018年 SandboxOL. All rights reserved.
//

import UIKit

protocol Reusable: class {
    
}

extension Reusable where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}


// MARK: UITableViewCell
extension UITableViewCell: Reusable { }


// MARK: UICollectionViewCell
extension UICollectionViewCell: Reusable { }
