//
//  DecorationControllerManager.swift
//  BlockyModes
//
//  Created by KiBen on 2018/1/10.
//  Copyright © 2018年 SandboxOL. All rights reserved.
//

import UIKit
import BlockModsGameKit
import SnapKit

class DecorationControllerManager {
    
    static let decorationControllerHeight = UIScreen.main.bounds.size.height * 0.43
    
    public static let shared = DecorationControllerManager()

    private var decorationController: BMDecorationViewController?
    private weak var parentController: UIViewController?
    private var decorationIDsDict: [String : String] = [:]

    public func add(toParent parent: UIViewController, layout: (ConstraintMaker) -> Void, finished: (() -> Void)? = nil) {
        if parentController == parent || parentController != nil {
            return
        }

        if decorationController == nil {
            initializeDecorationController()
        }

        parentController = parent
        parent.addChildViewController(decorationController!)
        if parent.view.subviews.count > 0 {
            parent.view.insertSubview(decorationController!.view, at: 0)
        }else {
            parent.view.addSubview(decorationController!.view)
        }
//        decorationController?.view.alpha = 0
        decorationController?.view.snp.makeConstraints { (make) in
            layout(make)
        }
        decorationController?.didMove(toParentViewController: parent)
        self.decorationController?.resume()
        if let finished = finished {
            finished()
        }
        
//        UIView.animate(withDuration: 0.25, animations: {
//            self.decorationController?.view.alpha = 1
//        }) { _ in
//            self.decorationController?.resume()
//            if let finished = finished {
//                finished()
//            }
//        }
    }

    public func removeFromParent() {
        decorationController?.view.snp.removeConstraints()
        decorationController?.suspend()
        decorationController?.view.removeFromSuperview()
        decorationController?.removeFromParentViewController()
        decorationController?.willMove(toParentViewController: nil)
        parentController = nil
    }

    public func destory() {
        guard decorationController != nil else {return}

        removeFromParent()
        decorationController = nil
    }

    public func suspendRendering() {
        decorationController?.suspend()
    }
    
    public func resumeRendering() {
        decorationController?.resume()
    }
    
    public func changeGender(_ gender: Int) {
        decorationController?.changeGender(Int32(gender))
    }

    public func useDecoration(resourceID: String) {
        guard resourceID.contains(".") else {
            useSkin(resourceID: resourceID)
            return
        }
        let key = resourceID.components(separatedBy: ".").first!
        decorationIDsDict[key] = resourceID
        decorationController?.useDecoration(withResourceID: resourceID)
    }

    public func unuseDecoration(resourceID: String) {
        guard resourceID.contains(".") else {
            unuseSkin(resourceID: resourceID)
            return
        }
        let key = resourceID.components(separatedBy: ".").first!
        decorationIDsDict.removeValue(forKey: key)
        decorationController?.unuseDecoration(withResourceID: resourceID)
        
    }
    
    public func resetToDefault() {
        for (_, resourceID) in decorationIDsDict {
            unuseDecoration(resourceID: resourceID)
        }
    }

    private func useSkin(resourceID: String) {
        decorationController?.useSkin(withResourceID: resourceID)
    }
    
    private func unuseSkin(resourceID: String) {
        decorationController?.unuseSkin(withResourceID: resourceID)
    }
    
    private func initializeDecorationController() {
        decorationController = BMDecorationViewController.init()
        decorationController!.generateFinished = { [unowned self] (controller) -> Void in
            guard let decorationController = controller else { return }
//            decorationController.changeGender(Int32(AccountInfoManager.shared.gender.value.rawValue))
            for (_, resourceID) in self.decorationIDsDict {
                self.useDecoration(resourceID: resourceID)
            }
        }
    }
}
