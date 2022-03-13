//
//  PopupBackButtonAuxiliary.swift
//  FTPopTransitionModule
//
//  Created by 🐶 on 3/5/22.
//

import Foundation



class PopupBackButtonAuxiliary {
    static let instance = PopupBackButtonAuxiliary.init()
    private init() {
        
    }
    
    private var transitionContext: UIViewControllerContextTransitioning?
    private var backAllAction: Bool = true
}

extension PopupBackButtonAuxiliary {
    func config(_ transitionContext: UIViewControllerContextTransitioning, backAllAction: Bool) {
        self.transitionContext = transitionContext
        self.backAllAction = backAllAction
    }
}

extension PopupBackButtonAuxiliary {
    @objc func backButtonAction(_ sender: UIButton) {
        guard let context = transitionContext, let to = context.viewController(forKey: .to) else {
            return
        }
        
        if backAllAction {
            to.dismiss(animated: true) {
                
            }
        }
        
    }
}
