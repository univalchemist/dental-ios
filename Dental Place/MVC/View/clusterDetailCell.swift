//
//  clusterDetailCell.swift
//  Moocher
//
//  Created by eWeb on 18/10/19.
//  Copyright © 2019 administrator. All rights reserved.
//

import UIKit

class clusterDetailCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var buutomView: UIView!
    @IBOutlet weak var endDatelbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var locLbl: UILabel!
    @IBOutlet weak var dataLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        buutomView.layer.cornerRadius = 10
        buutomView.layer.borderColor = UIColor.lightGray.cgColor
        
        buutomView.layer.borderWidth = 1
    }

}
