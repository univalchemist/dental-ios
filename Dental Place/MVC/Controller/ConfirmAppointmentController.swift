//
//  ConfirmAppointmentController.swift
//  Dental Place
//
//  Created by eWeb on 13/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit

class ConfirmAppointmentController: UIViewController
{

    @IBOutlet weak var BView: UIView!
    @IBOutlet weak var roundview: UIView!
    @IBOutlet weak var blueView: UIView!
    @IBOutlet var greyView: UIView!
    override func viewDidLoad()
    {
        super.viewDidLoad()

//        self.msgView.layer.cornerRadius = 10
        self.roundview.layer.cornerRadius = 20
        //self.blueView.layer.cornerRadius = 6
        self.greyView.layer.cornerRadius = 6
        self.BView.layer.cornerRadius = 6

        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    @IBAction func goBAck(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    
    
}
