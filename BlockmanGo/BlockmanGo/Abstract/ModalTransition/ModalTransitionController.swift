//
//  Transition.swift
//  BlockyModes
//
//  Created by KiBen on 2018/3/8.
//  Copyright © 2018年 SandboxOL. All rights reserved.
//

import UIKit

class ModalTransitionController: NSObject, UIViewControllerTransitioningDelegate {

    private let presentAnimation = PresentAnimatedTransition()
    private let dismissAnimation = DismissAnimatedTransition()
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentAnimation
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissAnimation
    }
    
    deinit {
        DebugLog("TransitionController Deinit")
    }
}
