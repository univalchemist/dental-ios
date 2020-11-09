//
//  AppointmentPopupViewController.swift
//  Dental Place
//
//  Created by eWeb on 17/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//


import UIKit


protocol AppoitnmentpopUpDataProtocol
{
    func inputData(data:String)
}
class AppointmentPopupViewController: UIViewController {
    @IBOutlet weak var btn2: UIButton!
    
    @IBOutlet weak var btn1: UIButton!
 
    var delegate:AppoitnmentpopUpDataProtocol? = nil
    
    var from = ""
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor
            .black.withAlphaComponent(0.5)
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        
        print("from = \(from)")
        /*
        if from=="Delete"
        {
            self.titleLbl.text = "Delete Image"
            self.messageLbl.text = "Are you sure want to delete this image?"
        }
        else if from=="Edit"
        {
            self.titleLbl.text = "Profile picture"
            self.messageLbl.text = "Make this image to your profile image?"
        }
        else if from=="Change Image"
        {
            self.titleLbl.text = "Image change"
            self.messageLbl.text = "Do you want to change this image?"
        }
        else if from=="Delete group"
        {
            self.titleLbl.text = "Delete Group"
            self.messageLbl.text = "Are you want to delete this group?"
        }
        else if from=="Delete Event"
        {
            self.titleLbl.text = "Delete Event"
            self.messageLbl.text = "Are you want to delete this event?"
        }
        else if from=="Delete Offer"
        {
            self.titleLbl.text = "Delete Offer"
            self.messageLbl.text = "Are you want to delete this offer?"
        }
        else if from=="Delete Account"
        {
            self.titleLbl.text = "Delete Account"
            self.messageLbl.text = "Are you want to delete this account?"
        }
        else if from=="Admin Delete Account"
        {
            self.titleLbl.text = "Delete Account"
            self.messageLbl.text = "Are you sure you want to delete your account this will be irreversible?"
        }
            
        else if from=="Block User"
        {
            self.titleLbl.text = "Block User"
            self.messageLbl.text = "Are you sure want to block this user?."
        }
        else if from=="Delete chat"
        {
            self.titleLbl.text = "Delete chat"
            self.messageLbl.text = "Remove this conversation and all messages on from this and recipients device?."
            
            self.btn1.setTitle("CANCEL", for: .normal)
            self.btn2.setTitle("YES", for: .normal)
        }
            
        else if from=="Send push notification"
        {
            self.btn1.setTitle("NO", for: .normal)
            
            self.titleLbl.text = "PROMOTE EVENT/OFFER NOTIFICATION"
            self.messageLbl.text = "DO YOU WANT TO PROMOTE THIS EVENT/OFFER?."
        }
        */
        
        
    }
    
    @IBAction func btn2Action(_ sender: UIButton)
    {
        //"Check Delegate nil"
        if(delegate != nil)
        {
            delegate?.inputData(data: sender.titleLabel?.text! ?? "cancel")
      
         
            
        }
            self.view.removeFromSuperview()
    }
    
    @IBAction func btn1Action(_ sender: UIButton)
    {
      if(delegate != nil)
         {
             delegate?.inputData(data: sender.titleLabel?.text! ?? "Re-schedule")
    
         }
        
        self.view.removeFromSuperview()
    }
}

