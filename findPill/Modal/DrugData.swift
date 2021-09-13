//
//  DrugData.swift
//  findPill
//
//  Created by Cem on 15.05.2021.
//

import Foundation


struct DrugData:Codable {
    var results:[Results]
}

struct Results:Codable {
    var term:String?
}
