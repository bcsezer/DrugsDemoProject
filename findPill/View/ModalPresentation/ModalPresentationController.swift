//
//  ModalPresentationController.swift
//  findPill
//
//  Created by Cem on 10.09.2021.
//

import UIKit

enum ModalScaleState {
    case presentation
    case interaction
}

class ModalPresentationController: UIPresentationController {
    private var presentedHeight: CGFloat = CGFloat(UIScreen.main.bounds.height) / 2.0
    private var lastLocation: CGFloat = 0
    private var state: ModalScaleState = .interaction
    private var isPan: Bool = true
    private lazy var dimmingView: UIView = {
        guard let containerView = containerView else { return UIView() }
        let view = UIView(frame: containerView.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(didTap(tap:)))
        )
        
        return view
    }()

    init(
        presentedViewController: UIViewController,
        presenting presentingViewController: UIViewController?,
        presentHeight: CGFloat,
        isPan: Bool,
        isPanEnabled: Bool = true
    ) {
        self.presentedHeight = presentHeight
        self.isPan = isPan
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        if isPanEnabled {
            presentedViewController.view.addGestureRecognizer(
                UIPanGestureRecognizer(target: self, action: #selector(didPan(pan:)))
            )
        }
    }
    
    @objc func didPan(pan: UIPanGestureRecognizer) {
        guard let view = pan.view, let superView = view.superview,
            let presented = presentedView, let container = containerView else { return }
        
        let location = pan.translation(in: superView)
        switch pan.state {
        case .began:
            if !self.isPan {
                presented.frame.size.height = container.frame.height
                presented.frame.origin.y = 0
            } else {
                presented.frame.size.height = container.frame.height - presented.frame.origin.y
            }
            
            lastLocation = presented.frame.origin.y
        case .changed:
            presented.frame.origin.y = location.y + lastLocation
            
            if !self.isPan {
                presented.frame.origin.y = max(0, location.y + lastLocation)
            } else {
                presented.frame.size.height = container.frame.height - presented.frame.origin.y
            }
        case .ended:
            if !isPan {
                if presented.frame.origin.y < presentedHeight / 10 {
                    UIView.animate(withDuration: 0.3) { [weak presented] in
                        presented?.frame.origin.y = 0
                    }
                } else {
                    presentedViewController.dismiss(animated: true, completion: nil)
                }
            } else {
                if presented.frame.origin.y.isLessThanOrEqualTo(0) || presented.frame.size.height < 2 * presentedHeight / 3 {
                    presentedViewController.dismiss(animated: true, completion: nil)
                }
            }
        default:
            break
        }
    }
    
    @objc func didTap(tap: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let container = containerView else { return .zero }
        
        return CGRect(
            x: 0,
            y: container.bounds.height - self.presentedHeight,
            width: container.bounds.width,
            height: self.presentedHeight
        )
    }
    
    override func presentationTransitionWillBegin() {
        guard let container = containerView,
            let coordinator = presentingViewController.transitionCoordinator else { return }
        
        dimmingView.alpha = 0
        container.addSubview(dimmingView)
        dimmingView.addSubview(presentedViewController.view)
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            guard let `self` = self else { return }
            
            self.dimmingView.alpha = 1
            }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentingViewController.transitionCoordinator else { return }
        
        coordinator.animate(alongsideTransition: { [weak self] (_) -> Void in
            guard let `self` = self else { return }
            
            self.dimmingView.alpha = 0
            }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
        }
    }
    
}

