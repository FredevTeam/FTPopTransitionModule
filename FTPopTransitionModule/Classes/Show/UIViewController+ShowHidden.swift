//
//  UIViewController+ShowHidden.swift
//  FTPopTransitionModule
//
//  Created by 🐶 on 3/5/22.
//

import Foundation

enum ViewControllerStatus {
    case normal
    case showing
}


extension UIViewController {

    public func hidden( animated flag: Bool, completion: (() -> Void)? = nil) {
        ShowAndHiddenAuxiliary.instance.hidden(flag ? 0.25 : 0) { to in
            var toVC = to
            if let nav = toVC as? UINavigationController {
                toVC = nav.viewControllers.first
            }
            
            if let alert = toVC as? AlertViewController {
                to?.view.frame = CGRect.init(x: (UIScreen.main.bounds.size.width - alert.view.frame.size.width ) / 2,
                                               y: UIScreen.main.bounds.size.height,
                                               width: alert.view.frame.size.width,
                                               height: alert.view.frame.size.height)
            }
            else if let popup = toVC as? PopupViewController {
                switch popup.orientationForPresentation() {
                case .portrait:
                    to?.view.frame = CGRect.init(x: 0,
                                                   y: UIScreen.main.bounds.size.height,
                                                   width: popup.view.frame.size.width,
                                                   height: popup.view.frame.size.height)
                    break
                case .landscape:
                    switch popup.direction {
                    case .portrait:
                        break
                    case .landscapeLeft:
                        to?.view.frame = CGRect.init(x: -UIScreen.main.bounds.size.width - popup.view.frame.size.width,
                                                       y: 0,
                                                       width: popup.view.frame.size.width,
                                                       height: popup.view.frame.size.height)
                        break
                    case .landscapeRight:
                        to?.view.frame = CGRect.init(x: UIScreen.main.bounds.size.width + popup.view.frame.size.width,
                                                       y: 0,
                                                       width: popup.view.frame.size.width,
                                                       height: popup.view.frame.size.height)
                        break
                    }
                    break
                }
            }else {
                to?.view.frame = CGRect.init(x: 0, y: -(toVC?.view.frame.size.height ?? 0), width: toVC?.view.frame.size.width ?? 0, height: toVC?.view.frame.size.height ?? 0)
            }
            
            
            toVC?._status = .normal
            
        } completion: { finished in
            ShowAndHiddenAuxiliary.instance.reset()
            completion?()
        }
    }
}


extension UIViewController {
    
    public func show(_ viewControllerToShow: UIViewController,back action: Bool = true, animated flag: Bool, completion: (() -> Void)? = nil) {
        var toViewController: UIViewController? = viewControllerToShow
        if let nav = toViewController as? UINavigationController {
            toViewController = nav.viewControllers.first
        }
        
        var backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
        var corner = UIRectCorner.init()
        var cornerRadius:CGFloat = 0
        var size = CGSize.zero
        let canAction = action
        let orientation = self.orientationForPresentation()
        var direction: PopupAnimationDirectionType = .portrait
        
        if let alert = toViewController as? AlertViewController {
            alert.view.layoutIfNeeded()
            backgroundColor = alert.popupBackgroundColor
            corner = alert.corner
            cornerRadius = alert.cornerRadius
            size = alert.size
            viewControllerToShow.view.frame = CGRect.init(x: (UIScreen.main.bounds.size.width - size.width ) / 2,
                                                          y: UIScreen.main.bounds.size.height,
                                                          width: size.width,
                                                          height: size.height)
        }
        
        else if let popup =  toViewController as? PopupViewController {
            popup.view.layoutIfNeeded()
            backgroundColor = popup.popBackgroundColor
            corner = popup.corner
            cornerRadius = popup.cornerRadius
            direction = popup.direction
            
            switch orientation {
            case .portrait:
                let height = popup.visibleVlaue < 1 ? UIScreen.main.bounds.height * popup.visibleVlaue : popup.visibleVlaue
                size = CGSize.init(width: UIScreen.main.bounds.size.width, height: height)
                viewControllerToShow.view.frame = CGRect.init(x: 0,
                                                              y: UIScreen.main.bounds.size.height,
                                                              width: size.width,
                                                              height: size.height)
                break
            case .landscape:
                let width = popup.visibleVlaue < 1 ? UIScreen.main.bounds.size.width * popup.visibleVlaue : popup.visibleVlaue
                size = CGSize.init(width: width, height: UIScreen.main.bounds.size.height )
                
                switch direction {
                case .portrait:
                    break
                case .landscapeLeft:
                    viewControllerToShow.view.frame = CGRect.init(x: -UIScreen.main.bounds.size.width - size.width,
                                                                  y: 0,
                                                                  width: size.width,
                                                                  height: size.height)
                    break
                case .landscapeRight:
                    viewControllerToShow.view.frame = CGRect.init(x: UIScreen.main.bounds.size.width + size.width,
                                                                  y: 0,
                                                                  width: size.width,
                                                                  height: size.height)
                    break
                }
                break
            }
            
        }else {
            // TODO: 普通的view
            size = viewControllerToShow.view.frame.size
            switch orientation {
            case .landscape:
                viewControllerToShow.view.frame = CGRect.init(x: (UIScreen.main.bounds.size.width - size.width ) / 2, y: UIScreen.main.bounds.size.height, width:  size.width, height:  size.height)
                break
            case .portrait:
                viewControllerToShow.view.frame = CGRect.init(x: (UIScreen.main.bounds.size.width - size.width ) / 2, y: UIScreen.main.bounds.size.height, width: size.width, height:  size.height)
                break
            }
        }
        
        
        viewControllerToShow.view.alpha = 0
        let mask = CAShapeLayer.init()
        mask.path = UIBezierPath.init(roundedRect: viewControllerToShow.view.bounds,
                                      byRoundingCorners: corner,
                                      cornerRadii: CGSize.init(width: cornerRadius, height: cornerRadius)).cgPath
        viewControllerToShow.view.layer.mask = mask
        
        ShowAndHiddenAuxiliary.instance.config(self, to: viewControllerToShow, backButton: canAction, backgroundColor: backgroundColor)
        ShowAndHiddenAuxiliary.instance.show(flag ? 0.25 : 0) {
            viewControllerToShow.view.alpha = 1
            
            if let _ = toViewController as? PopupViewController {
                switch orientation {
                case .portrait:
                    viewControllerToShow.view.frame = CGRect.init(x: 0,
                                                                  y: UIScreen.main.bounds.size.height - size.height,
                                                                  width: size.width,
                                                                  height: size.height)
                    break
                case .landscape:
                    switch direction {
                    case .portrait:
                        break
                    case .landscapeLeft:
                        viewControllerToShow.view.frame = CGRect.init(x: 0,
                                                                      y: 0,
                                                                      width: size.width,
                                                                      height: size.height)
                        break
                    case .landscapeRight:
                        viewControllerToShow.view.frame = CGRect.init(x: UIScreen.main.bounds.size.width - size.width,
                                                                      y: 0,
                                                                      width: size.width,
                                                                      height: size.height)
                        break
                    }
                    break
                }
                
            }else if let _ = toViewController as? AlertViewController {
                viewControllerToShow.view.frame  = CGRect.init(x: (UIScreen.main.bounds.size.width - size.width ) / 2,
                                                               y: (UIScreen.main.bounds.size.height - size.height ) / 2,
                                                               width: size.width,
                                                               height: size.height)
            }else {
                    viewControllerToShow.view.frame = CGRect.init(x: 0,
                                                                  y: 0,
                                                                  width: size.width,
                                                                  height: size.height)
            }
            
            
            
            
            toViewController?._status = .showing
            
            
            
        } completion: { finished in
            completion?()
        }
    }
    
}


extension UIViewController {
    func orientationForPresentation() -> InterfaceOrientation {
        let presentation = self.preferredInterfaceOrientationForPresentation
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
