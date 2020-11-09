//
//  SearchServiceTableViewCell.swift
//  Dental Place
//
//  Created by AMARENDRA on 09/04/20.
//  Copyright © 2020 eWeb. All rights reserved.
//
import UIKit
import FloatRatingView

class SearchServiceTableViewCell: UITableViewCell
{
    @IBOutlet weak var seeAllBtn: UIButton!
    
    @IBOutlet weak var serviceCostLbl: UILabel!
    @IBOutlet weak var searviceNamelbl: UILabel!
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
    
    @IBOutlet weak var serviceView: UIView!
    @IBOutlet weak var topConst: NSLayoutConstraint!
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
