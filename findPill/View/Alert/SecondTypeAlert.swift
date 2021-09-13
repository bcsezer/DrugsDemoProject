//
//  SecondTypeAlert.swift
//  findPill
//
//  Created by Cem on 16.05.2021.
//

import Foundation
import UIKit

struct SecondTypeAlert {
    
    static func showAlert(on vc:UIViewController, with title:String,Message:String){
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        vc.present(alert, animated: true, completion: nil)
    }
   
}
