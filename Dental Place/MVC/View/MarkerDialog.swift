//
//  MarkerDialog.swift
//  Moocher
//
//  Created by eWeb on 10/09/19.
//  Copyright © 2019 administrator. All rights reserved.
//

import UIKit

class MarkerDialog: UIView {
    @IBOutlet var markerBtn: UIButton!
    
    @IBOutlet var groupName: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        self.groupName.layer.cornerRadius = self.groupName.frame.height/2
    }

    
    func loadView() -> MarkerDialog
    {
        let customInfoWindow = Bundle.main.loadNibNamed("MarkerDialog2", owner: self, options: nil)?[0] as! MarkerDialog
        return customInfoWindow
    }
}
