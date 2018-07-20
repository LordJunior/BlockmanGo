//
//  TransitionManager.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/9.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit

class TransitionManager: NSObject {
    
    static func currentNavigationController() -> UINavigationController? {
        guard let stackTopViewController = self.stack.stackTopViewController else {return nil}
        if stackTopViewController is UINavigationController {
            return stackTopViewController as? UINavigationController
        }else if stackTopViewController is UITabBarController {
            return (stackTopViewController as? UITabBarController)?.selectedViewController as? UINavigationController
        }else {
            return stackTopViewController.navigationController
        }
    }
    
    static func pushViewController(_ viewControllerToPush: UIViewController.Type, animated: Bool, parameter: Any? = nil) {
        let controllerToPush = controllerWithType(viewControllerToPush, parameter: parameter)
        currentNavigationController()?.pushViewController(controllerToPush, animated: animated)
    }
    
    static func popViewController(animated: Bool) {
        currentNavigationController()?.popViewController(animated: animated)
    }
    
    static func popToRootViewController(animated: Bool) {
        currentNavigationController()?.popToRootViewController(animated: animated)
    }
    
    static func present(_ viewControllerToPresent: UIViewController.Type, animated: Bool, needNavigation: Bool = false, parameter: Any? = nil, completion: (() -> Void)? = nil) {
        let controllerToPresent = controllerWithType(viewControllerToPresent, parameter: parameter)
        controllerToPresent.parameter = parameter
        var appearViewController = controllerToPresent
        if needNavigation {
            appearViewController = navigationClass.init()
            (appearViewController as! UINavigationController).pushViewController(controllerToPresent, animated: false)
        }
        let disappearController = self.stack.stackTopViewController
        disappearController?.present(appearViewController, animated: animated, completion: {
            completion?()
            self.stack.pushViewController(appearViewController)
        })
    }
    
    static func dismiss(animated: Bool, completion: (() -> Void)? = nil) {
        if self.stack.size > 1 {
            self.stack.popViewController()
            let appearViewController = self.stack.stackTopViewController
            appearViewController?.dismiss(animated: animated, completion: completion)
        }
    }
    
    private static func controllerWithType(_ controllerType: UIViewController.Type, parameter: Any?) -> UIViewController {
        let controller = controllerType.init()
        controller.parameter = parameter
        return controller
    }
}

extension TransitionManager {
    private static var _TransitionManagerRootViewController: CChar = CChar.init(0)
    private static var _TransitionManagerNavigationClass: CChar = CChar.init(0)
    
    static var rootViewController: UIViewController {
        set {
            self.stack.popAllViewControllers()
            self.stack.pushViewController(newValue)
            objc_setAssociatedObject(self, &(TransitionManager._TransitionManagerRootViewController), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &(TransitionManager._TransitionManagerRootViewController)) as! UIViewController
        }
    }
    
    static var navigationClass: UINavigationController.Type {
        set {
            objc_setAssociatedObject(self, &(TransitionManager._TransitionManagerNavigationClass), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &(TransitionManager._TransitionManagerNavigationClass)) as! UINavigationController.Type
        }
    }
}

extension TransitionManager {
    private static var _TransitionManagerViewControllerStack: CChar = CChar.init(0)
    
    fileprivate static var stack: TransitionManagerStack {
        get {
            let optionalStack = objc_getAssociatedObject(self, &(TransitionManager._TransitionManagerViewControllerStack)) as? TransitionManagerStack
            guard let stack = optionalStack else {
                let stack = TransitionManagerStack()
                objc_setAssociatedObject(self, &(TransitionManager._TransitionManagerViewControllerStack), stack, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return stack
            }
            return stack
        }
    }
}

extension UIViewController {
    private static var _TransitionManagerViewControllerParamter: CChar = CChar.init(0)
    
    var parameter: Any? {
        set {
            objc_setAssociatedObject(self, &(UIViewController._TransitionManagerViewControllerParamter), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &(UIViewController._TransitionManagerViewControllerParamter))
        }
    }
}
