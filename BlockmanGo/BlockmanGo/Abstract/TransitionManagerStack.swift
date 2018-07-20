//
//  TransitionManagerStack.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/9.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit

class TransitionManagerStack {
    private var _viewControllers: [UIViewController] = []
    
    var stackTopViewController: UIViewController? {
        return _viewControllers.last
    }
    
    var size: Int {
        return _viewControllers.count
    }
    
    var viewControllers: [UIViewController] {
        return _viewControllers
    }
    
    func pushViewController(_ controllerToStack: UIViewController) {
        _viewControllers.append(controllerToStack)
    }
    
    func popViewController() {
        _viewControllers.removeLast()
    }
    
    func popAllViewControllers() {
        _viewControllers.removeAll()
    }
}
