//
//  PresentAnimation.swift
//  BlockyModes
//
//  Created by KiBen Hung on 2018/3/6.
//  Copyright © 2018年 SandboxOL. All rights reserved.
//

import UIKit

class PresentAnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {

    var hidePresenting: Bool = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.01
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromController = transitionContext.viewController(forKey: .from)
        let toController = transitionContext.viewController(forKey: .to)
        
        let finalFrame = transitionContext.finalFrame(for: toController!)
        toController?.view.frame = finalFrame.offsetBy(dx: 0, dy: UIScreen.main.bounds.height)
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toController!.view)
        
        let animationInterval = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: animationInterval, delay: 0, usingSpringWithDamping: 0.65 , initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            toController?.view.frame = finalFrame
            fromController?.view.alpha = self.hidePresenting ? 0 : 1
        }) { (finished) in
            if finished {
                transitionContext.completeTransition(finished)
            }
        }
    }
    
    deinit {
        DebugLog("PresentAnimatedTransition Deinit")
    }
}
