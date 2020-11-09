//
//  TimeTableTableViewCell.swift
//  Dental Place
//
//  Created by AMARENDRA on 08/04/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit

class TimeTableTableViewCell: UITableViewCell {
    @IBOutlet weak var bckView: UIView!
    
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
