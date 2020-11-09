//
//  AllcommentTableCell.swift
//  Dental Place
//
//  Created by eWeb on 13/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit
import FloatRatingView

class AllcommentTableCell: UITableViewCell
{
    @IBOutlet weak var messagelbl: UILabel!
    
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var avgrating: UILabel!
    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var username: UILabel!
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
