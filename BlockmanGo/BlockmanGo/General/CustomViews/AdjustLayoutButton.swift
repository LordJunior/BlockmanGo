//
//  AdjustLayoutButton.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/8/28.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit

class AdjustLayoutButton: UIButton {

    enum ContentLayout {
        case imageLeftTitleRight // default
        case imageRightTitleLeft
        case imageTopTitleBottom
        case imageBottomTitleTop
    }
    
    var contentLayout: ContentLayout = .imageLeftTitleRight {
        didSet {
            setNeedsLayout()
        }
    }
    
    var padding: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel?.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        titleLabel?.textAlignment = .center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard !self.bounds.isEmpty, imageView != nil, titleLabel != nil else {return}
        
        resizeSubviews()
        
        switch contentLayout {
        case .imageLeftTitleRight:
            imageLeftTitleRightLayout(buttonSize: bounds.size, imageViewSize: imageView!.size, titleLabelSize: titleLabel!.size)
        case .imageRightTitleLeft:
            imageRightTitleLeftLayout(buttonSize: bounds.size, imageViewSize: imageView!.size, titleLabelSize: titleLabel!.size)
        case .imageTopTitleBottom:
            imageTopTitleBottomLayout(buttonSize: bounds.size, imageViewSize: imageView!.size, titleLabelSize: titleLabel!.size)
        case .imageBottomTitleTop:
            imageBottomTitleTopLayout(buttonSize: bounds.size, imageViewSize: imageView!.size, titleLabelSize: titleLabel!.size)
        }
    }
    
    private func resizeSubviews() {
        titleLabel?.sizeToFit()
        switch contentLayout {
        case .imageLeftTitleRight, .imageRightTitleLeft:
            if titleLabel!.bounds.size.width > (bounds.width - padding - imageView!.bounds.size.width) {
                titleLabel?.bounds.size.width = bounds.width
            }
        default:
            if titleLabel!.bounds.size.width > bounds.width {
                titleLabel?.bounds.size.width = bounds.width
            }
        }
    }
    
    private func imageLeftTitleRightLayout(buttonSize: CGSize, imageViewSize: CGSize, titleLabelSize: CGSize) {
        switch contentHorizontalAlignment {
        case .left:
            imageView?.frame.origin.x = 0
            imageView?.frame.origin.y = (buttonSize.height - imageViewSize.height) / 2
            titleLabel?.frame.origin.x = imageView!.frame.maxX + padding
            titleLabel?.frame.origin.y = (buttonSize.height - titleLabelSize.height) / 2
        case .right:
            titleLabel?.frame.origin.x = buttonSize.width - titleLabelSize.width
            titleLabel?.frame.origin.y = (buttonSize.height - titleLabelSize.height) / 2
            imageView?.frame.origin.x = titleLabel!.frame.minX - padding - imageViewSize.width
            imageView?.frame.origin.y = (buttonSize.height - imageViewSize.height) / 2
        default:
            imageView?.frame.origin.x = buttonSize.width * 0.5 - (titleLabelSize.width + padding + imageViewSize.width) * 0.5
            imageView?.frame.origin.y = (buttonSize.height - imageViewSize.height) / 2
            titleLabel?.frame.origin.x = imageView!.frame.maxX + padding
            titleLabel?.frame.origin.y = (buttonSize.height - titleLabelSize.height) / 2
        }
    }
    
    private func imageRightTitleLeftLayout(buttonSize: CGSize, imageViewSize: CGSize, titleLabelSize: CGSize) {
        switch contentHorizontalAlignment {
        case .left:
            titleLabel?.frame.origin.x = 0
            titleLabel?.frame.origin.y = (buttonSize.height - imageViewSize.height) / 2
            imageView?.frame.origin.x = titleLabel!.bounds.maxX + padding
            imageView?.frame.origin.y = (buttonSize.height - titleLabelSize.height) / 2
        case .right:
            imageView?.frame.origin.x = buttonSize.width - imageViewSize.width
            imageView?.frame.origin.y = (buttonSize.height - imageViewSize.height) / 2
            titleLabel?.frame.origin.x = imageView!.frame.minX - padding - titleLabelSize.width
            titleLabel?.frame.origin.y = (buttonSize.height - titleLabelSize.height) / 2
        default:
            titleLabel?.frame.origin.x = buttonSize.width * 0.5 - (titleLabelSize.width + padding + imageViewSize.width) * 0.5
            titleLabel?.frame.origin.y = (buttonSize.height - titleLabelSize.height) / 2
            imageView?.frame.origin.x = titleLabel!.frame.maxX + padding
            imageView?.frame.origin.y = (buttonSize.height - imageViewSize.height) / 2
        }
    }
    
    private func imageTopTitleBottomLayout(buttonSize: CGSize, imageViewSize: CGSize, titleLabelSize: CGSize) {
        switch contentVerticalAlignment {
        case .top:
            imageView?.frame.origin.y = 0
            imageView?.frame.origin.x = (buttonSize.width - imageViewSize.width) / 2
            titleLabel?.frame.origin.y = imageView!.frame.maxY + padding
            titleLabel?.frame.origin.x = (buttonSize.width - titleLabelSize.width) / 2
        case .bottom:
            titleLabel?.frame.origin.y = buttonSize.height - titleLabelSize.height
            titleLabel?.frame.origin.x = (buttonSize.width - titleLabelSize.width) / 2
            imageView?.frame.origin.y = titleLabel!.frame.minY - padding - imageViewSize.height
            imageView?.frame.origin.x = (buttonSize.width - imageViewSize.width) / 2
        default:
            imageView?.frame.origin.y = buttonSize.height * 0.5 - (titleLabelSize.height + padding + imageViewSize.height) * 0.5
            imageView?.frame.origin.x = (buttonSize.width - imageViewSize.width) / 2
            titleLabel?.frame.origin.y = imageView!.frame.maxY + padding
            titleLabel?.frame.origin.x = (buttonSize.width - titleLabelSize.width) / 2
        }
    }
    
    private func imageBottomTitleTopLayout(buttonSize: CGSize, imageViewSize: CGSize, titleLabelSize: CGSize) {
        switch contentVerticalAlignment {
        case .top:
            titleLabel?.frame.origin.y = 0
            titleLabel?.frame.origin.x = (buttonSize.width - imageViewSize.width) / 2
            imageView?.frame.origin.y = titleLabel!.bounds.maxY + padding
            imageView?.frame.origin.x = (buttonSize.width - titleLabelSize.width) / 2
        case .bottom:
            imageView?.frame.origin.y = buttonSize.height - imageViewSize.height
            imageView?.frame.origin.x = (buttonSize.width - imageViewSize.width) / 2
            titleLabel?.frame.origin.y = imageView!.frame.minY - padding - titleLabelSize.height
            titleLabel?.frame.origin.x = (buttonSize.width - titleLabelSize.width) / 2
        default:
            titleLabel?.frame.origin.y = buttonSize.height * 0.5 - (titleLabelSize.height + padding + imageViewSize.height) * 0.5
            titleLabel?.frame.origin.x = (buttonSize.width - imageViewSize.width) / 2
            imageView?.frame.origin.y = titleLabel!.frame.maxY + padding
            imageView?.frame.origin.x = (buttonSize.width - titleLabelSize.width) / 2
        }
    }
}
