//
//  GravityImageView.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/31.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit
import CoreMotion

class GravityImageView: UIView {

    private weak var imageView: UIImageView?
    private let motionManager = CMMotionManager()
    private let operationQueue = OperationQueue()
    
    required init(image: UIImage?) {
        super.init(frame: .zero)
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        self.imageView = imageView
        
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: operationQueue, withHandler: { (deviceMotion, error) in
                guard error == nil else {
                    print("startGyroUpdates error: \(error!)")
                    self.motionManager.stopGyroUpdates()
                    return
                }

                guard let deviceMotion = deviceMotion else {return}
                print("startGyroUpdates x: \(deviceMotion.rotationRate.x) y: \(deviceMotion.rotationRate.y) z: \(deviceMotion.rotationRate.z)  thread: \(Thread.current)")
            })
//            motionManager.startGyroUpdates(to: operationQueue, withHandler: { (gyroData, error) in
//                guard error == nil else {
//                    print("startGyroUpdates error: \(error!)")
//                    self.motionManager.stopGyroUpdates()
//                    return
//                }
//                guard let gyroData = gyroData else {return}
//                print("startGyroUpdates x: \(gyroData.rotationRate.x) y: \(gyroData.rotationRate.y) z: \(gyroData.rotationRate.z)  thread: \(Thread.current)")
//            })
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.frame = bounds
    }
}
