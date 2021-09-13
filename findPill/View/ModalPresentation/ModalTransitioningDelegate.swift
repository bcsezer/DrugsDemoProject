//
//  ModalTransitioningDelegate.swift
//  findPill
//
//  Created by Cem on 10.09.2021.
//

import Foundation
import UIKit

final class ModalTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var interactiveDismiss = true
    var presentHeight: CGFloat
    var isPan: Bool
    var isPanEnabled: Bool = true
    
    init(to presenting: UIViewController, height: CGFloat, isPan: Bool, isPanEnabled: Bool = true) {
        presentHeight = height
        self.isPan = isPan
        self.isPanEnabled = isPanEnabled
        super.init()
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        nil
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        ModalPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            presentHeight: presentHeight,
            isPan: isPan,
            isPanEnabled: isPanEnabled)
    }
    
    func interactionControllerForDismissal(
        using animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        nil
    }
    
}
