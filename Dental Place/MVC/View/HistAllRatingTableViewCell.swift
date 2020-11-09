//
//  HistAllRatingTableViewCell.swift
//  Dental Place
//
//  Created by AMARENDRA on 20/04/20.
//  Copyright © 2020 eWeb. All rights reserved.
//
import FloatRatingView
import UIKit

class HistAllRatingTableViewCell: UITableViewCell {
    @IBOutlet weak var ratingV: FloatRatingView!
    @IBOutlet weak var allreviewBtn: UIButton!
    @IBOutlet weak var ratinglbl: UILabel!
    
    @IBOutlet weak var servicename: UILabel!
    @IBOutlet weak var backview: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
