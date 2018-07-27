//
//  LaunchBrandingViewController.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/27.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit

class LaunchBrandingViewController: UIViewController {

    private weak var brandingImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        brandingImageView = UIImageView(image: R.image.branding()).addTo(superView: view).layout(snapKitMaker: { (make) in
            make.center.equalToSuperview()
        }).configure({ (imageView) in
            imageView.alpha = 0.0
            imageView.transform = CGAffineTransform.init(translationX: 0, y: -view.height * 0.3)
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        triggerAnimation()
    }
    
    private func triggerAnimation() {
        UIView.animate(withDuration: 0.85, delay: 0, options: .curveEaseOut, animations: {
            self.brandingImageView?.alpha = 1.0
            self.brandingImageView?.transform = CGAffineTransform.identity
        }) { (finished) in
            if finished {
                delay(0.5, exeute: {
                    TransitionManager.pushViewController(LaunchViewController.self, animated: false)
                })
            }
        }
    }
}
