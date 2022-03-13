//
//  PopupAnimation.swift
//  FTPopTransitionModule
//
//  Created by 🐶 on 3/5/22.
//

import Foundation


public enum PopupAnimationDirectionType {
    case portrait
    case landscapeRight
    case landscapeLeft
}
enum InterfaceOrientation {
    case portrait
    case landscape
}


class PopupAnimation: NSObject {
    var dudation:TimeInterval = 0.25
    var visibleValue: CGFloat = UIScreen.main.bounds.height * 0.7 {
        didSet {
            if visibleValue < 1 {
                visibleValue = UIScreen.main.bounds.height * visibleValue
            }
        }
    }
    var backgroundColor: UIColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
    var corner: UIRectCorner = UIRectCorner.init()
    var cornerRadius: CGFloat = 0
    var backAllAction = true
    var direction: PopupAnimationDirectionType = .portrait
    private var backButton = UIButton.init(type: .custom)
    
    override init() {
        super.init()
        
    }
}

extension PopupAnimation :UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        self.dudation
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)
        let toVC = transitionContext.viewController(forKey: .to)
        if toVC?.presentingViewController == fromVC {
            presentTransition(transitionContext)
        }else {
            dismissTransition(transitionContext)
        }
    }
}

extension PopupAnimation {
    private func presentTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let from = transitionContext.viewController(forKey: .from)
        let to = transitionContext.viewController(forKey: .to)
        let containerView = transitionContext.containerView
        
        guard let fromVC = from, let toVC = to, let tempView = fromVC.view.snapshotView(afterScreenUpdates: false) else {
            return
        }
        
        let orientation = self.orientationFor(fromVC.preferredInterfaceOrientationForPresentation)
        
        tempView.frame = fromVC.view.frame
        fromVC.view.isHidden = true

        containerView.addSubview(tempView)
        containerView.addSubview(toVC.view)

        if orientation == .landscape {
            switch direction {
            case .landscapeRight:
                toVC.view.frame = CGRect.init(x: UIScreen.main.bounds.size.width, y: 0, width: visibleValue, height: containerView.frame.size.height)
                break
            case .landscapeLeft:
                fallthrough
            default:
                toVC.view.frame = CGRect.init(x: -visibleValue, y: 0, width: visibleValue, height: containerView.frame.size.height)
            }
        }else {
            toVC.view.frame = CGRect.init(x: 0, y: containerView.frame.size.height, width: containerView.frame.size.width, height: visibleValue)
        }

        // backButton
        backButton.frame = fromVC.view.bounds
        backButton.addTarget(PopupBackButtonAuxiliary.instance, action: #selector(PopupBackButtonAuxiliary.backButtonAction(_:)), for: .touchUpInside)
        PopupBackButtonAuxiliary.instance.config(transitionContext, backAllAction: backAllAction)
        containerView.insertSubview(backButton, aboveSubview: tempView)
        if self.cornerRadius > 0 {
            let mask = CAShapeLayer.init()
            mask.path = UIBezierPath.init(roundedRect: toVC.view.bounds, byRoundingCorners: self.corner, cornerRadii: CGSize.init(width: self.cornerRadius, height: self.cornerRadius)).cgPath
            toVC.view.layer.mask = mask
        }

        backButton.alpha = 0
        backButton.backgroundColor = self.backgroundColor

        UIView.animate(withDuration: self.transitionDuration(using: transitionContext)) {
            self.backButton.alpha = 1;
            if orientation != .landscape {
                toVC.view.transform = CGAffineTransform.init(translationX: 0, y: -self.visibleValue)
                return
            }
            switch self.direction {
                case .landscapeRight:
                toVC.view.transform = CGAffineTransform.init(translationX: -self.visibleValue, y: 0)
                case .landscapeLeft:
                toVC.view.transform = CGAffineTransform.init(translationX: self.visibleValue, y: 0)
                default:
                toVC.view.transform = CGAffineTransform.init(translationX: 0, y: -self.visibleValue)
            }
        }completion: { finished in
            let cancel = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!cancel)
            if cancel {
                fromVC.view.isHidden = false
                self.backButton.alpha = 0
                self.backButton.backgroundColor = .clear
                tempView.removeFromSuperview()
                self.backButton.removeFromSuperview()
            }
        }

    }
}

extension PopupAnimation {
    private func dismissTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)
        let toVC = transitionContext.viewController(forKey: .to)
        
        let tempView = transitionContext.containerView.subviews.filter { view in
                   "\(view)".contains("UIReplicantView")
               }.first
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext)) {
            fromVC?.view.transform = .identity
            tempView?.transform = .identity
            self.backButton.backgroundColor = .clear
        }completion: { finished in
            let cancel = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!cancel)
            if !cancel {
                toVC?.view.isHidden = false
                tempView?.removeFromSuperview()
                self.backButton.removeFromSuperview()
            }
        }
    }
}


extension PopupAnimation {
    private func orientationFor(_ presentation: UIInterfaceOrientation) -> InterfaceOrientation {
        switch presentation {
        case .unknown:
            fallthrough
        case .portrait:
            fallthrough
        case .portraitUpsideDown:
            return .portrait
        case .landscapeLeft:
            fallthrough
        case .landscapeRight:
            return .landscape
        }
    }
}
