//
//  Animatable.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/18.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation

protocol Animatable: class {
    func makeBreathAnimation(duration: TimeInterval, delay: TimeInterval)
    func makeInfiniteTranslationAnimation(x: CGFloat, y: CGFloat, duration: TimeInterval, delay: TimeInterval)
}

extension Animatable where Self: UIView {
    func makeBreathAnimation(duration: TimeInterval, delay: TimeInterval = 0) {
        layer.removeAnimation(forKey: "BreathAnimation")
        
        let breathAnimation = CABasicAnimation(keyPath: "opacity");
        breathAnimation.duration = duration
        breathAnimation.fromValue = 1.0
        breathAnimation.toValue = 0.0
        breathAnimation.repeatCount = Float.greatestFiniteMagnitude
        breathAnimation.beginTime = CACurrentMediaTime() + delay
        breathAnimation.autoreverses = true
        layer.add(breathAnimation, forKey: "BreathAnimation")
    }
    
    func makeInfiniteTranslationAnimation(x: CGFloat, y: CGFloat, duration: TimeInterval, delay: TimeInterval = 0) {
        layer.removeAnimation(forKey: "InfiniteTranslationAnimation")
        
        let translateXAnimation = CABasicAnimation(keyPath: "transform.translation.x");
        translateXAnimation.fromValue = NSNumber(value: Float(self.frame.origin.x))
        translateXAnimation.toValue = NSNumber(value: Float(self.frame.origin.x + x))
        
        let translateYAnimation = CABasicAnimation(keyPath: "transform.translation.y");
        translateYAnimation.fromValue = NSNumber(value: Float(self.frame.origin.y))
        translateYAnimation.toValue = NSNumber(value: Float(self.frame.origin.y + y))
        
        let translateGroup = CAAnimationGroup()
        translateGroup.beginTime = CACurrentMediaTime() + delay
        translateGroup.animations = [translateXAnimation, translateYAnimation]
        translateGroup.duration = duration
        translateGroup.repeatCount = Float.greatestFiniteMagnitude
        
        layer.add(translateGroup, forKey: "InfiniteTranslationAnimation")
    }
}

extension UIView: Animatable {}
