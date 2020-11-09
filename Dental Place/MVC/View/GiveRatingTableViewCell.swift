//
//  GiveRatingTableViewCell.swift
//  Dental Place
//
//  Created by AMARENDRA on 20/04/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit

class GiveRatingTableViewCell: UITableViewCell {
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var arrowBtn: UIButton!
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var expandBtn: UIButton!
    @IBOutlet weak var rateBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
