//
//  Transition.swift
//  BlockyModes
//
//  Created by KiBen on 2018/3/8.
//  Copyright © 2018年 SandboxOL. All rights reserved.
//

import UIKit

class ModalTransitionController: NSObject, UIViewControllerTransitioningDelegate {
    
    static let hidePresentingTransition = ModalTransitionController(hidePresenting: true)
    
    static let normalTransition = ModalTransitionController()
    
    private var presentAnimation: UIViewControllerAnimatedTransitioning?
    private var dismissAnimation: UIViewControllerAnimatedTransitioning?
    
    required init(hidePresenting: Bool = false) {
        super.init()
        
        let presentAnimation = PresentAnimatedTransition()
        presentAnimation.hidePresenting = hidePresenting
        self.presentAnimation = presentAnimation
        dismissAnimation = DismissAnimatedTransition()
    }

    private override init() {
        super.init()
        
        presentAnimation = PresentAnimatedTransition()
        dismissAnimation = DismissAnimatedTransition()
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentAnimation
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissAnimation
    }
    
    deinit {
        DebugLog("ModalTransitionController Deinit")
    }
}
