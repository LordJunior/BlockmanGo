//
//  DismissAnimation.swift
//  BlockyModes
//
//  Created by KiBen on 2018/3/7.
//  Copyright © 2018年 SandboxOL. All rights reserved.
//

import UIKit

class DismissAnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.01
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let toController = transitionContext.viewController(forKey: .to)
        let fromController = transitionContext.viewController(forKey: .from)
        let finalFrame = transitionContext.finalFrame(for: fromController!)
        
        let animationInterval = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: animationInterval, animations: {
            fromController?.view.frame = finalFrame.offsetBy(dx: 0, dy: UIScreen.main.bounds.height)
            toController?.view.alpha = 1.0
        }) { (finished) in
            if finished {
                fromController?.view.removeFromSuperview()
                transitionContext.completeTransition(finished)
            }
        }
    }
    
    deinit {
        DebugLog("DismissAnimatedTransition Deinit")
    }
}
