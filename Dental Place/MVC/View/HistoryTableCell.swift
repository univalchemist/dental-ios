//
//  HistoryTableCell.swift
//  Dental Place
//
//  Created by eWeb on 12/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit

class HistoryTableCell: UITableViewCell {

    
    
    
    @IBOutlet weak var allReviewPopup: UIView!
    
    @IBOutlet weak var allReviewBtn: UIButton!
   
    
    @IBOutlet weak var ratePopup: UIView!
    
    @IBOutlet weak var rateBtn: UIButton!
    
    @IBOutlet weak var rateDownArrow: UIButton!
    
    @IBOutlet weak var uiview: UIView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
