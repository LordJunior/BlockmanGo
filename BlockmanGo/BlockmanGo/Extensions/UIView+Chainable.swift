//
//  UIView+Chainable.swift
//  BlockyModes
//
//  Created by KiBen on 2017/11/3.
//  Copyright © 2017年 SandboxOL. All rights reserved.
//

import Foundation
import SnapKit

protocol ViewChainable {
}

extension ViewChainable where Self: UIView {
    @discardableResult
    func configure(_ config: (Self) -> Void) -> Self {
        config(self)
        return self
    }
}

extension UIView: ViewChainable {
    func addTo(superView: UIView) -> Self {
        superView.addSubview(self)
        return self
    }
    
    @discardableResult
    func layout(snapKitMaker: (ConstraintMaker) -> Void) -> Self {
        self.snp.makeConstraints { (make) in
            snapKitMaker(make)
        }
        return self
    }
}
