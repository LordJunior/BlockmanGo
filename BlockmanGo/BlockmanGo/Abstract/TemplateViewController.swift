//
//  TemplateViewController.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/9.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit

class TemplateViewController: UIViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        modalPresentationStyle = .custom
        transitioningDelegate = ModalTransitionController()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
}
