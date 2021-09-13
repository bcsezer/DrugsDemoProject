//
//  FavoritesTableViewCell.swift
//  findPill
//
//  Created by Cem on 2.05.2021.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {

    @IBOutlet weak var drugName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
