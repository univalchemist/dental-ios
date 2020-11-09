//
//  chatTableCell.swift
//  Dental Place
//
//  Created by eWeb on 13/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit

class chatTableCell: UITableViewCell
{
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
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
