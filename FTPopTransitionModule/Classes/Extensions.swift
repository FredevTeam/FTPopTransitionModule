//
//  Extensions.swift
//  FTPopTransitionModule
//
//  Created by 🐶 on 3/5/22.
//

import Foundation



extension UIViewController {
    private struct AssociatedKeys {
        static var kViewControllerStatus = "kViewControllerStatus"
    }

    var _status:ViewControllerStatus {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.kViewControllerStatus) as? ViewControllerStatus ?? .normal
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.kViewControllerStatus, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    public func dismissOrHiddenSubViewController() {
        for vc in self.childViewControllers {
            if let nav = vc as? UINavigationController {
                dismissOrHidden(nav.viewControllers.first, navivationController: nav)
            }else {
                dismissOrHidden(vc, navivationController: nil)
            }
        }
    }
}

extension UIViewController {
    private func dismissOrHidden(_ viewController: UIViewController?, navivationController: UINavigationController?) {
        guard let viewController = viewController else {
            return
        }
        switch viewController._status {
                
            case .normal:
                break
            case .showing:
                if let nav = navivationController {
                    nav.hidden(animated: true, completion: nil)
                }else {
                    viewController.hidden(animated: true, completion: nil)
                }
        }
    }
}

