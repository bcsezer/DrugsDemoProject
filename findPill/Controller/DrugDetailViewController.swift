//
//  DrugDetailViewController.swift
//  findPill
//
//  Created by Cem on 2.05.2021.
//

import UIKit

class DrugDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
       loadData()

        // Do any additional setup after loading the view.
    }
    
    func loadData(){
        if let selectedDrug = SelectedDrug.shared.selectedDrug{
            nameLabel.text = selectedDrug.name
            noteLabel.text = selectedDrug.note
            categoryLabel.text = selectedDrug.category
            print(selectedDrug)
        }
    }

}
