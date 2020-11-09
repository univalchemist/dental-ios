//
//  WelcomeScreen.swift
//  Dental Place
//
//  Created by eWeb on 11/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit

class WelcomeScreen: UIViewController
{

    @IBOutlet weak var getStart: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getStart.layer.cornerRadius = 6
    }

    @IBAction func getStartAct(_ sender: UIButton)
    {
        var wecomeScreenOne = self.storyboard?.instantiateViewController(withIdentifier: "wecomeScreenOne") as! wecomeScreenOne
        self.navigationController?.pushViewController(wecomeScreenOne, animated: true)
        
        
        
    }
    
}
