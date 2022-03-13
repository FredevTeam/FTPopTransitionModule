//
//  ShowAndHiddenAuxiliary.swift
//  FTPopTransitionModule
//
//  Created by 🐶 on 3/5/22.
//

import Foundation



class ShowAndHiddenAuxiliary {
    static let  instance = ShowAndHiddenAuxiliary.init()
    private init() {
        self.backButton .addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.backButton.frame = UIScreen.main.bounds
        self.backButton.alpha = 0
    }
    
    private(set) var showing: Bool = false
    private weak var from: UIViewController?
    private weak var to: UIViewController?
    private var backButton = UIButton.init(type: .custom)
    private var backButtonCanAction: Bool = false
}

extension ShowAndHiddenAuxiliary {
    func config(_ from: UIViewController?, to: UIViewController?, backButton canAction: Bool, backgroundColor:UIColor ) {
        if self.from != nil || self.to != nil {
            debugPrint("PopupShowAndHiddenAuxiliary func config 重复设置")
            return
        }
        
        self.from = from
        self.to = to
        
        if self.backButton.superview == nil {
            keyWindow?.addSubview(self.backButton)
        }
        self.backButton.backgroundColor = backgroundColor
        self.backButtonCanAction = canAction
    }
}

extension ShowAndHiddenAuxiliary {
    func  reset() {
        self.showing = false
        self.from = nil
        self.to = nil
        backButtonCanAction = false
        self.backButton.removeFromSuperview()
    }
    
    
    var keyWindow: UIWindow? {
        var currentWindow = UIApplication.shared.keyWindow
        UIApplication.shared.windows.forEach { window in
            if window.isMember(of: UIWindow.classForCoder()),
                window.rootViewController != nil,
               !window.isHidden,window.bounds.size == UIScreen.main.bounds.size {
                currentWindow = window
            }
        }
        guard let currentWindow = currentWindow else {
            debugPrint("[Debug] keyWindow is nil, uiapplication windows maybe is empty or keyWindow is nil")
            return nil
        }
        return currentWindow
    }

}



extension ShowAndHiddenAuxiliary {
    @objc private func buttonAction() {
        if self.backButtonCanAction {
            self.to?.hidden(animated: true)
        }
    }
}


extension ShowAndHiddenAuxiliary {
    func hidden(_ duration: TimeInterval,animation: ((_ to: UIViewController?) -> Void)? = nil, completion: ((_ finished: Bool) -> Void)? = nil) {
        if !showing {
            return
        }
        UIView.animate(withDuration: duration) {
            self.backButton.alpha = 0
            self.to?.view.alpha = 0
            animation?(self.to)
        } completion: { finished in
            completion?(finished)
        }

    }
}

extension ShowAndHiddenAuxiliary {
    func show(_ duration: TimeInterval,animation: (() -> Void)? = nil, completion: ((_ finished: Bool) -> Void)? = nil) {
        if showing {
            return
        }
        self.showing = true
        guard let to = to else {
            return
        }
        keyWindow?.addSubview(to.view)
        self.from?.addChildViewController(to)
        UIView.animate(withDuration: duration) {
            self.backButton.alpha = 1
            self.to?.view.alpha = 1
            animation?()
        }completion: { finished in
            completion?(finished)
        }
        
    }
}
