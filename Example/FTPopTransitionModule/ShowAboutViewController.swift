//
//  ViewController.swift
//  FTPopTransitionModule
//
//  Created by fredevteam on 03/05/2022.
//  Copyright (c) 2022 fredevteam. All rights reserved.
//

import UIKit
import FTPopTransitionModule


class ShowAboutViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
            self.navigationController?.popViewController(animated: true)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissOrHiddenSubViewController()
    }
    
}



extension ShowAboutViewController {
    
    
    @IBAction func showLeftAction(_ sender: Any) {
        let presentvc = FTPresentViewController.init()
        let nav = UINavigationController.init(rootViewController: presentvc)
        presentvc.infectNavigationController = true
        presentvc.direction =  .landscapeLeft
        self.show(nav, animated: true, completion: nil)
    }
    @IBAction func showRightAction(_ sender: Any) {
        let presentvc = FTPresentViewController.init()
        let nav = UINavigationController.init(rootViewController: presentvc)
        presentvc.infectNavigationController = true
        presentvc.direction =  .landscapeRight
        self.show(nav, animated: true, completion: nil)
    }
    
    
    @IBAction func showAction(_ sender: Any) {
        self.show(FTPresentViewController.init(), animated: true, completion: nil)
    }
    
    @IBAction func showNavAction(_ sender: Any) {
        let presentvc = FTPresentViewController.init()
        let nav = UINavigationController.init(rootViewController: presentvc)
        presentvc.infectNavigationController = true
        self.show(nav, animated: true, completion: nil)
    }
    

    @IBAction func showAlertAction(_ sender: Any) {
        self.show(FTAlertViewController.init(), animated: true, completion: nil)
    }
    
    
}
