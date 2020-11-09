//
//  CategoryTableViewCell.swift
//  Dental Place
//
//  Created by AMARENDRA on 01/04/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var catNameLbl: UILabel!
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
             
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
