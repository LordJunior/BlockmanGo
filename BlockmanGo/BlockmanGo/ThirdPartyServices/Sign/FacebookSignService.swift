//
//  ThirdLoginManager.swift
//  BlockyModes
//
//  Created by KiBen Hung on 2018/1/29.
//  Copyright © 2018年 SandboxOL. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import FBSDKCoreKit

protocol FacebookSignServiceDelegate: class {
    func sign(_ signIn: FacebookSignService, didSignFor openID: String, token: String)
    func sign(_ signIn: FacebookSignService, didSignFailed: Error)
    func signDidCanceled(_ signIn: FacebookSignService)
}

struct FacebookSignService {
    
    weak var delegate: FacebookSignServiceDelegate?
    
    private weak var fromViewController: UIViewController?
    
    init(from sourceViewController: UIViewController) {
        fromViewController = sourceViewController
    }
    
    static func initializeSDK(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    static func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    static func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(app , open: url, options: options)
    }
    
    func signIn() {
        let login = FBSDKLoginManager()
        login.logOut()
        login.logIn(withReadPermissions: ["public_profile"], from: fromViewController!) {(result, error) in
            guard !result!.isCancelled else {
                self.delegate?.signDidCanceled(self)
                return
            }
            guard error == nil, let token = result?.token else {
                self.delegate?.sign(self, didSignFailed: error!)
                return
            }
            self.delegate?.sign(self, didSignFor: token.userID, token: token.tokenString)
        }
    }
}
