//
//  UIView+Extension.swift
//  BlockyModes
//
//  Created by KiBen on 2017/10/19.
//  Copyright © 2017年 SandboxOL. All rights reserved.
//

import UIKit

extension UIView {
    var x: CGFloat {
        set(x) {
            frame.origin.x = x
        }
        
        get {
            return frame.origin.x
        }
    }
    
    var y: CGFloat {
        set(y) {
            frame.origin.y = y
        }
        
        get {
            return frame.origin.y
        }
    }
    
    var width: CGFloat {
        set(width) {
            frame.size.width = width
        }
        
        get {
            return frame.size.width
        }
    }
    
    var height: CGFloat {
        set(height) {
            frame.size.height = height
        }
        
        get {
            return frame.size.height
        }
    }
    
    var size: CGSize {
        set(size) {
            frame.size = size
        }
        
        get {
            return frame.size
        }
    }
    
    var centerX: CGFloat {
        set(centerX) {
            center.x = centerX
        }
        
        get {
            return center.x
        }
    }
    
    var centerY: CGFloat {
        set(centerY) {
            center.y = centerY
        }
        
        get {
            return center.y
        }
    }
    
    var maxX: CGFloat {
        get {
            return self.x + self.width
        }
    }
    
    var maxY: CGFloat {
        get {
            return self.y + self.height
        }
    }
}
