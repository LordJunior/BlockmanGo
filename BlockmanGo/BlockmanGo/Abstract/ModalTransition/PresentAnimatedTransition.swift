//
//  PresentAnimation.swift
//  BlockyModes
//
//  Created by KiBen Hung on 2018/3/6.
//  Copyright © 2018年 SandboxOL. All rights reserved.
//

import UIKit

class PresentAnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let toController = transitionContext.viewController(forKey: .to)
        
        let finalFrame = transitionContext.finalFrame(for: toController!)
        toController?.view.frame = finalFrame.offsetBy(dx: 0, dy: UIScreen.main.bounds.height)
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toController!.view)
        
        let animationInterval = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: animationInterval, delay: 0, usingSpringWithDamping: 0.65 , initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            toController?.view.frame = finalFrame
        }) { (finished) in
            if finished {
                transitionContext.completeTransition(finished)
            }
        }
    }
    
    deinit {
        DebugLog("PresentAnimation Deinit")
    }
}
