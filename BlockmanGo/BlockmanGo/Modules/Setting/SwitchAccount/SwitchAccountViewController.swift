//
//  SwitchAccountViewController.swift
//  BlockmanGo
//
//  Created by KiBen Hung on 2018/8/23.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import UIKit

class SwitchAccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        TransitionManager.dismiss(animated: true)
    }
}
