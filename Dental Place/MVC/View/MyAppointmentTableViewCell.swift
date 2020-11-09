//
//  MyAppointmentTableViewCell.swift
//  Dental Place
//
//  Created by eWeb on 17/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit

class MyAppointmentTableViewCell: UITableViewCell {
    @IBOutlet weak var clinicNameLbl: UILabel!
    
    @IBOutlet weak var seeDirectionBtn: UIButton!
    @IBOutlet weak var locLbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var servicenamelbl: UILabel!
    @IBOutlet weak var threeDotsBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
