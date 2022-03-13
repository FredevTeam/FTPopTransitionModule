//
//  PopupViewController.swift
//  FTPopTransitionModule
//
//  Created by 🐶 on 3/5/22.
//

import Foundation


open class PopupViewController: UIViewController {
    
    public var visibleVlaue: CGFloat = 0.7 {
        didSet {
            animation.visibleValue = visibleVlaue
        }
    }
    public  var popBackgroundColor:UIColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2) {
        didSet {
            animation.backgroundColor = popBackgroundColor
        }
    }
    public var corner: UIRectCorner = UIRectCorner.init() {
        didSet {
                animation.corner = corner
        }
    }
    public  var cornerRadius:  CGFloat = 0 {
        didSet {
            animation.cornerRadius = cornerRadius
        }
    }
    public var direction: PopupAnimationDirectionType = .landscapeRight  {
        didSet {
            animation.direction = direction
        }
    }
    
    
    public var infectNavigationController: Bool = false {
        didSet {
            if infectNavigationController , let nav = self.navigationController {
                nav.transitioningDelegate = self.transitioningDelegate
                nav.modalPresentationStyle = .custom
            }
        }
    }
    open override var transitioningDelegate: UIViewControllerTransitioningDelegate? {
        didSet {
            if transitioningDelegate?.isEqual(self.popupTransitioningDelegate) ?? false {
                return
            }
            transitioningDelegate = self.popupTransitioningDelegate
        }
    }
    open override var modalPresentationStyle: UIModalPresentationStyle {
        didSet {
            if modalPresentationStyle !=  .custom {
                modalPresentationStyle = .custom
            }
        }
    }


    private var popupTransitioningDelegate:PopupTransitioningDelegate?
    private var animation = PopupAnimation.init()
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        popupTransitioningDelegate = PopupTransitioningDelegate.init(animation, viewController: self)
        self.transitioningDelegate = popupTransitioningDelegate
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint("PopupViewController init")
    }
}

extension PopupViewController {
    open override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
    }
}



class PopupTransitioningDelegate: NSObject {
    private var animation:PopupAnimation
    private weak var viewController: PopupViewController?
    init(_ animation: PopupAnimation, viewController: PopupViewController) {
        self.animation = animation
        self.viewController = viewController
    }
}

extension PopupTransitioningDelegate:UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if (viewController?.infectNavigationController ?? false), let _ = viewController?.navigationController {
            viewController?.navigationController?.transitioningDelegate = viewController?.transitioningDelegate
            viewController?.navigationController?.modalPresentationStyle = .custom
        }
        return animation
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animation
    }
}
