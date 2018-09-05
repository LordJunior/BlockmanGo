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

struct LoginService {
    
    private weak var fromViewController: UIViewController?
    
    init(from sourceViewController: UIViewController) {
        fromViewController = sourceViewController
    }
    
    static public func initializeSDK(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    static public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
//    public func logInByFaceBook() -> Single<(String, String)> {
//        return Single<(String, String)>.create(subscribe: { (single) -> Disposable in
//            guard let fromViewController = self.fromViewController else {
//                return Disposables.create()
//            }
//
//            let manager = FBSDKLoginManager()
//            manager.logOut()
//            manager.loginBehavior = FBSDKLoginBehavior.native
//            manager.logIn(withReadPermissions: ["public_profile"], from: fromViewController) { (result, error) in
//                guard result?.token != nil else {
//                    single(.error(BlockyError.unKnown))
//                    return
//                }
//                single(.success((result!.token.userID, result!.token.tokenString)))
//                DebugLog("facebook token string -- \(result!.token.tokenString)")
//            }
//            return Disposables.create()
//        })
//    }
}
