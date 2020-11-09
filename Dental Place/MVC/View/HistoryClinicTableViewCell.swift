//
//  HistoryClinicTableViewCell.swift
//  Dental Place
//
//  Created by AMARENDRA on 20/04/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit

class HistoryClinicTableViewCell: UITableViewCell {
    @IBOutlet weak var clinicname: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var timelbl: UILabel!
    @IBOutlet weak var arrowBtn: UIButton!
    
    @IBOutlet weak var servceName: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
