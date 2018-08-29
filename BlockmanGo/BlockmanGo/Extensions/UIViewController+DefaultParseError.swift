//
//  UIViewController+DefaultParseError.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/8/29.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation

extension UIViewController {
    func defaultParseError(_ error: BlockHTTPError) {
        switch error {
        case .unauthorized:
            PrepareLauncher.resetRootViewControllerToLaunch()
        default:
            AlertController.alert(title: R.string.localizable.common_request_fail_retry(), message: nil, from: self)
        }
    }
}
