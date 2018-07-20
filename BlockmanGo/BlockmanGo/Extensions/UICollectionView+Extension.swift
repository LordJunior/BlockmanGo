//
//  UICollectionView+Extension.swift
//  BlockyModes
//
//  Created by KiBen Hung on 2018/1/7.
//  Copyright © 2018年 SandboxOL. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(cellForClass cell: T.Type) {
        register(cell, forCellWithReuseIdentifier: cell.reuseIdentifier)
    }
    
    func register<T: UICollectionViewCell>(cellForNib cell: T.Type) {
        let nib = UINib(nibName: cell.reuseIdentifier, bundle: nil)
        register(nib, forCellWithReuseIdentifier: cell.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Can not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}
