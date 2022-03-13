//
//  FTPresentViewController.swift
//  FTPopTransitionModule_Example
//
//  Created by 🐶 on 3/5/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import FTPopTransitionModule
import UIKit

class FTPresentViewController: PopupViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton.init(type: .custom)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.frame = CGRect.init(x: 100, y: 100, width: 100, height: 50)
        button.setTitle("Push\(self.navigationController?.viewControllers.count ?? 0)", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        view.addSubview(button)
    }
    
    deinit {
        debugPrint("FTPresentViewController init")
    }
}


extension FTPresentViewController {
    @objc private func buttonAction() {
        let vc = FTPresentViewController.init()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
