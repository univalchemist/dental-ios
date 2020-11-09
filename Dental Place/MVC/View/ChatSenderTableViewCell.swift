//
//  ChatSenderTableViewCell.swift
//  Dental Place
//
//  Created by AMARENDRA on 22/04/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit

class ChatSenderTableViewCell: UITableViewCell {
    @IBOutlet weak var clinicName: UILabel!
       
    @IBOutlet weak var senderTime: UILabel!
    @IBOutlet weak var messagetext: UITextView!
       @IBOutlet weak var messageView: UIView!
       @IBOutlet weak var timelbl: UILabel!
       @IBOutlet weak var onlineImg: UIImageView!
       @IBOutlet weak var profileimg: UIImageView!
       @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
