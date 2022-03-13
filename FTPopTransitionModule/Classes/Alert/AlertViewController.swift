//
//  AlertViewController.swift
//  FTPopTransitionModule
//
//  Created by 🐶 on 3/5/22.
//

import Foundation


open class AlertViewController: UIViewController {
    private var alertAnimation = AlertAnimation.init()
    private var alertTransitioningDelegate:AlertTransitioningDelegate
    
    public var size: CGSize = CGSize.init(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 2) {
        didSet {
            alertAnimation.size = size
        }
    }
    public var popupBackgroundColor: UIColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2) {
        didSet {
            alertAnimation.popupBackgroundColor = popupBackgroundColor
        }
    }
    public var corner: UIRectCorner = UIRectCorner.init() {
        didSet {
            alertAnimation.corner = corner
        }
    }
    public var cornerRadius: CGFloat = 0 {
        didSet {
            alertAnimation.cornerRadius = cornerRadius
        }
    }
    
    public var duration: TimeInterval = 0.15 {
        didSet {
            alertAnimation.duration = duration
        }
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.alertTransitioningDelegate = AlertTransitioningDelegate.init(alertAnimation)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.transitioningDelegate = self.alertTransitioningDelegate
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        debugPrint("AlertViewController deinit")
    }
}

extension AlertViewController {

    public override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.white
    }
    public override var transitioningDelegate: UIViewControllerTransitioningDelegate? {
        didSet {
            if transitioningDelegate?.isEqual(self.alertTransitioningDelegate) ?? false {
                return
            }
            transitioningDelegate = self.alertTransitioningDelegate
        }
    }
    public override var modalPresentationStyle: UIModalPresentationStyle {
        didSet {
            if modalPresentationStyle != .custom {
                modalPresentationStyle = .custom
            }
        }
    }
}
