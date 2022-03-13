//
//  PresentAboutViewController.swift
//  FTPopTransitionModule_Example
//
//  Created by 🐶 on 3/5/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import FTPopTransitionModule

class PresentAboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissOrHiddenSubViewController()
    }
    
    
    
}


extension PresentAboutViewController {
    
    @IBAction func presentAction(_ sender: Any) {
        self.present(FTPresentViewController.init(), animated: true, completion: nil)
    }
    
    @IBAction func alertViewAction(_ sender: Any) {
        self.present(FTAlertViewController.init(), animated: true, completion: nil)
    }
    
    @IBAction func presentNavAction(_ sender: Any) {
        let presentvc = FTPresentViewController.init()
        let nav = UINavigationController.init(rootViewController: presentvc)
        presentvc.infectNavigationController = true
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func leftAction(_ sender: Any) {
        let presentvc = FTPresentViewController.init()
        let nav = UINavigationController.init(rootViewController: presentvc)
        presentvc.infectNavigationController = true
        presentvc.direction =  .landscapeLeft
        self.present(nav, animated: true, completion: nil)
    }
    // 右侧(竖屏无效设置，还是显示竖屏)
    @IBAction func rightAction(_ sender: Any) {
        let presentvc = FTPresentViewController.init()
        let nav = UINavigationController.init(rootViewController: presentvc)
        presentvc.infectNavigationController = true
        presentvc.direction =  .landscapeRight
        self.present(nav, animated: true, completion: nil)
    }
    
}
