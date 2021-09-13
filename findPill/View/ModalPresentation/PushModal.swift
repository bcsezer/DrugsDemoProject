//
//  PushModal.swift
//  findPill
//
//  Created by Cem on 10.09.2021.
//

import Foundation
import UIKit

class pushModal {
    static func pushModal(viewController: UIViewController, animated: Bool, heightRatio: CGFloat? = nil, isPan: Bool, isPanEnabled: Bool = true,navigation:UINavigationController) {
           // Remove previous views with same class
        navigation.viewControllers = navigation.viewControllers.filter { controller in
               type(of: controller) != type(of: viewController)
           }
           
           let transitioningDelegate = ModalTransitioningDelegate(
               to: viewController,
               height: CGFloat(UIScreen.main.bounds.height) * (heightRatio ?? 3/4),
               isPan: isPan,
               isPanEnabled: isPanEnabled
           )
           
           transitioningDelegate.interactiveDismiss = false
          
           viewController.modalPresentationStyle = .custom
           viewController.transitioningDelegate = transitioningDelegate
           
           // Push view
           navigation.present(viewController, animated: true, completion: nil)
       }
    
}
