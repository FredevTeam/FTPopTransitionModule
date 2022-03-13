//
//  AlertAnimation.swift
//  FTPopTransitionModule
//
//  Created by 🐶 on 3/5/22.
//

import Foundation



class AlertTransitioningDelegate : NSObject {
    private var animation:AlertAnimation
    init(_ animation: AlertAnimation) {
        self.animation = animation
    }
}
extension AlertTransitioningDelegate : UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animation.showing = false
        return animation
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animation.showing = true
        return animation
    }
}


class AlertAnimation: NSObject {
    
    var popupBackgroundColor: UIColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
    var corner:UIRectCorner = UIRectCorner.init()
    var cornerRadius:CGFloat = 0
    var showing: Bool = false
    var size:CGSize = CGSize.init(width: UIScreen.main.bounds.size.width - 40, height: UIScreen.main.bounds.size.height * 0.3)
    var duration: TimeInterval = 0.15
    var backAllAction: Bool = true
    
    private var context:UIViewControllerContextTransitioning?
    private var button = UIButton.init(type: .custom)
    override init() {
        super.init()
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
}


extension AlertAnimation : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.context = transitionContext
        if self.showing {
            showingAnimation(transitionContext)
        }else {
            hiddenAnimation(transitionContext)
        }
    }
}


extension AlertAnimation {
    private func showingAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)
        let  toVC = transitionContext.viewController(forKey: .to)
        let  containterView = transitionContext.containerView

        if let fromVC = fromVC, let toVC = toVC, let tempView = fromVC.view.snapshotView(afterScreenUpdates: false) {
            
            tempView.frame = fromVC.view.frame;
            fromVC.view.isHidden = true
            containterView.addSubview(tempView)
            containterView.addSubview(toVC.view)
            toVC.view.frame = CGRect.init(x:(containterView.frame.size.width - self.size.width) / 2,
                                          y: (containterView.frame.size.height - self.size.height) / 2,
                                          width: size.width,
                                          height: size.height)
            button.frame = fromVC.view.bounds
            containterView.insertSubview(button, aboveSubview: tempView)
            
            if self.cornerRadius > 0 {
                let mask = CAShapeLayer.init()
                mask.path = UIBezierPath.init(roundedRect: toVC.view.bounds, byRoundingCorners: self.corner, cornerRadii: CGSize.init(width: self.cornerRadius, height: self.cornerRadius)).cgPath
                toVC.view.layer.mask = mask
            }


            let duration = self.transitionDuration(using: transitionContext)
            button.alpha = 0
            button.backgroundColor = popupBackgroundColor
            toVC.view.alpha = 0

            if toVC.view.translatesAutoresizingMaskIntoConstraints {
                debugPrint("translatesAutoresizingMaskIntoConstraints is false transition is not work")
            }

            UIView.animate(withDuration: duration) {
                self.button.alpha = 1
                toVC.view.alpha = 1
            }completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                if transitionContext.transitionWasCancelled {
                    fromVC.view.isHidden = false
                    self.button.alpha = 0
                    toVC.view.alpha = 0
                    self.button.backgroundColor = .clear
                    tempView.removeFromSuperview()
                    self.button.removeFromSuperview()
                }
            }
        }
    }
}

extension AlertAnimation{
    private func  hiddenAnimation (_ transitionContext: UIViewControllerContextTransitioning){
        let fromVC = transitionContext.viewController(forKey: .from)
        let  toVC = transitionContext.viewController(forKey: .to)
        let  containterView = transitionContext.containerView

        if let fromVC = fromVC, let toVC = toVC {
            let tempView = containterView.subviews.filter { view in
                       "\(view)".contains("UIReplicantView")
                   }.first

            let duration = self.transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration) {
                self.button.backgroundColor = .clear
                fromVC.view.alpha = 0
            }completion: { finished in
                let cancel = transitionContext.transitionWasCancelled
                transitionContext.completeTransition(!cancel)
                if cancel {
                    fromVC.view.isHidden = false
                    fromVC.view.alpha = 1
                }else {
                    fromVC.view.isHidden = true
                    fromVC.view.alpha = 0
                    tempView?.removeFromSuperview()
                    self.button.removeFromSuperview()
                    toVC.view.isHidden = false
                    toVC.view.alpha = 1
                }
            }
        }
    }
}

extension AlertAnimation {
    @objc private func buttonAction() {
        if let context = context, self.backAllAction, let toVC = context.viewController(forKey: .to) {
            toVC.dismiss(animated: true, completion: nil)
        }
    }
}



