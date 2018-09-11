//
//  ClosableProtocol.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/8/22.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation
import SnapKit

protocol ClosableProtocol {
    func addCloseButton(layout: (ConstraintMaker) -> Void, handler: @escaping (UIButton) -> Void)
}

let closeButtonSize = CGSize(width: 45, height: 47)

extension UIViewController: ClosableProtocol {
    
    private static var closeHandlerKey: Void?
    
    private var closeHandler: ((UIButton) -> Void) {
        set {
            objc_setAssociatedObject(self, &(UIViewController.closeHandlerKey), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &(UIViewController.closeHandlerKey)) as! ((UIButton) -> Void)
        }
    }
    
    func addCloseButton(layout: (ConstraintMaker) -> Void, handler: @escaping (UIButton) -> Void) {
        closeHandler = handler
        UIButton().addTo(superView: self.view).configure({ (button) in
            button.setBackgroundImage(R.image.general_close(), for: .normal)
            button.addTarget(self, action: #selector(closeButtonClicked(sender:)), for: .touchUpInside)
        }).layout(snapKitMaker: layout)
    }
    
    @objc private func closeButtonClicked(sender: UIButton) {
        closeHandler(sender)
    }
}

