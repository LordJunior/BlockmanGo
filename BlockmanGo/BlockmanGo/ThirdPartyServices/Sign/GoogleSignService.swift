//
//  GoogleLoginService.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/9/6.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation
import GoogleSignIn

protocol GoogleSignServiceUIDelegate: class {
    func sign(inWillDispath signIn: GoogleSignService)
    func sign(_ signIn: GoogleSignService, present viewController: UIViewController)
    func sign(_ signIn: GoogleSignService, dismiss viewController: UIViewController)
}

protocol GoogleSignServiceDelegate: class {
    func sign(_ signIn: GoogleSignService, didSignFor openID: String, token: String)
    func sign(_ signIn: GoogleSignService, didSignFailed: Error)
}

class GoogleSignService: NSObject {
    weak var delegate: GoogleSignServiceDelegate?
    weak var uiDelegate: GoogleSignServiceUIDelegate?
    
    override init() {
        super.init()
        GIDSignIn.sharedInstance().clientID = "320914605590-7sccs9in33anb56lusf5rhqotnv88d41.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    static func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    func signIn() {
        GIDSignIn.sharedInstance().signIn()
    }
}

extension GoogleSignService: GIDSignInUIDelegate {
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        uiDelegate?.sign(inWillDispath: self)
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        uiDelegate?.sign(self, present: viewController)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        uiDelegate?.sign(self, dismiss: viewController)
    }
}

extension GoogleSignService: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            delegate?.sign(self, didSignFailed: error)
        } else {
            delegate?.sign(self, didSignFor: user.userID, token: user.authentication.idToken)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        DebugLog("signIn: GIDSignIn!, didDisconnectWith \(error.localizedDescription)")
    }
}
