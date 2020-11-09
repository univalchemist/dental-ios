//
//  ListAndMapTableCell.swift
//  Dental Place
//
//  Created by eWeb on 16/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit
import FloatRatingView

class ListAndMapTableCell: UITableViewCell
{
    @IBOutlet weak var seeAllBtn: UIButton!
    
    @IBOutlet weak var ratingNumber: UILabel!
    @IBOutlet weak var mainview: UIView!
    @IBOutlet weak var bookAppBtn: UIButton!
    @IBOutlet weak var ratingV: FloatRatingView!
    
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var ratingLbl: UIButton!
    @IBOutlet weak var closeLbl: UILabel!
    @IBOutlet weak var openlbl: UILabel!
    @IBOutlet weak var locLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
