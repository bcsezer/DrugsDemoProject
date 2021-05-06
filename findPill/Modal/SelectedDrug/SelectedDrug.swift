//
//  SelectedDrug.swift
//  findPill
//
//  Created by Cem on 6.05.2021.
//

import Foundation
import Foundation

//MARK: Selected Article Singleton
class SelectedDrug{
    
    static let shared = SelectedDrug()
    
    lazy var selectedDrug: PillModel! = nil
        
}
