//
//  GravityImageView.swift
//  BlockmanGo
//
//  Created by KiBen Hung on 2018/8/1.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit
import CoreMotion

class GravityImageView: UIView {

    private weak var imageView: UIImageView?
    private let motionManager = CMMotionManager()
    private let operationQueue = OperationQueue.main
    
    required init(image: UIImage?) {
        super.init(frame: .zero)
        
        imageView = UIImageView(image: image).addTo(superView: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.frame = CGRect(x: 0, y: 0, width: bounds.width * 1.1, height: bounds.height * 1.1)
        imageView?.center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
    }
    
    func startGravityMotion() {
        guard motionManager.isDeviceMotionAvailable else {
            return
        }
        
        let heightDiff = imageView!.height - bounds.size.height
        let widthDiff = imageView!.width - bounds.size.width
        motionManager.deviceMotionUpdateInterval = 1 / 60
        motionManager.startDeviceMotionUpdates(to: operationQueue) { (motion, error) in
            guard let motion = motion, error == nil else {
                self.motionManager.stopDeviceMotionUpdates()
                return
            }
            DispatchQueue.main.async {
                self.imageView?.frame.origin.x += CGFloat(1.5 * motion.rotationRate.x)
                if self.imageView!.frame.origin.x > 0 {
                    self.imageView?.frame.origin.x = 0
                }else if self.imageView!.frame.origin.x <= -widthDiff {
                    self.imageView?.frame.origin.x = -widthDiff
                }
                
                self.imageView?.frame.origin.y += CGFloat(1.5 * motion.rotationRate.y)
                if self.imageView!.frame.origin.y > 0 {
                    self.imageView?.frame.origin.y = 0
                }else if self.imageView!.frame.origin.y <= -heightDiff {
                    self.imageView?.frame.origin.y = -heightDiff
                }
            }
        }
    }
    
    func stopGravityMotion() {
        motionManager.stopDeviceMotionUpdates()
    }
}
