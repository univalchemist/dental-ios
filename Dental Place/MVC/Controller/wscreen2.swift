//
//  wscreen2.swift
//  Dental Place
//
//  Created by eWeb on 11/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit

class wscreen2: UIViewController
{

   
    @IBOutlet weak var nxtt: UIView!
    @IBOutlet weak var backk: UIView!
    @IBOutlet weak var male: UIView!
    @IBOutlet weak var femaleBtn: UIView!
    @IBOutlet weak var maleLbl: UILabel!
    @IBOutlet weak var femaleLbl: UILabel!
    @IBOutlet weak var maleImg: UIImageView!
    @IBOutlet weak var femaleImg: UIImageView!
    
    var firstName = ""
    
    var lastName = ""
    var selectedGender = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.selectedGender = "Male"
        self.male.layer.cornerRadius = 6
        self.nxtt.layer.cornerRadius = 6
        self.femaleBtn.layer.cornerRadius = 6
        self.femaleBtn.layer.borderWidth = 1
        self.femaleBtn.layer.borderColor = UIColor(red: 193/255.0, green: 206/255.0, blue: 218/255.0, alpha: 1).cgColor
        self.backk.layer.cornerRadius = 6
        self.backk.layer.borderWidth = 1
        self.backk.layer.borderColor = UIColor(red: 35/255.0, green: 166/255.0, blue: 152/255.0, alpha: 1).cgColor
        
        
        self.male.backgroundColor = UIColor(red: 11/255.0, green: 200/255.0, blue: 180/255.0, alpha: 1)//UIColor(red: 35/255.0, green: 166/255.0, blue: 152/255.0, alpha: 1)
        self.femaleBtn.backgroundColor = UIColor.clear
        
        maleImg.image = UIImage(named: "Path 111")
        femaleImg.image = UIImage(named: "Group 141")
        
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.selectedGender="Male"
        DEFAULT.set("Male", forKey: "GENDER")
        DEFAULT.synchronize()
    }
    @IBAction func back(_ sender: UIButton)
    {
        
       self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func skip(_ sender: UIButton)
    {
        let WelcmThree = self.storyboard?.instantiateViewController(withIdentifier: "WelcmThree") as! WelcmThree
        self.navigationController?.pushViewController(WelcmThree, animated: true)
        
    }
    @IBAction func Next(_ sender: UIButton)
    {
        
        let WelcmThree = self.storyboard?.instantiateViewController(withIdentifier: "WelcmThree") as! WelcmThree
       
        WelcmThree.firstName = self.firstName
        WelcmThree.lastName = self.lastName
        WelcmThree.gender = self.selectedGender
        
        self.navigationController?.pushViewController(WelcmThree, animated: true)
        
        
    }
    
    @IBAction func femaleAct(_ sender: UIButton)
    {
//        self.femaleBtn.backgroundColor = UIColor(red: 35/255.0, green: 166/255.0, blue: 152/255.0, alpha: 1)
           self.femaleBtn.backgroundColor = UIColor(red: 11/255.0, green: 200/255.0, blue: 180/255.0, alpha: 1)
        self.male.backgroundColor = UIColor.clear
        self.male.layer.cornerRadius = 6
        self.male.layer.borderWidth = 1
        self.male.layer.borderColor = UIColor(red: 193/255.0, green: 206/255.0, blue: 218/255.0, alpha: 1).cgColor
        maleLbl.textColor = UIColor(red: 79/255.0, green: 112/255.0, blue: 148/255.0, alpha: 1)
        femaleLbl.textColor = UIColor(red: 231/255.0, green: 251/255.0, blue: 249/255.0, alpha: 1)
        maleImg.image = UIImage(named: "Group 155")
        femaleImg.image = UIImage(named: "Component 1 – 1")
        self.selectedGender = "Female"
        
        DEFAULT.set("Female", forKey: "GENDER")
        DEFAULT.synchronize()
        
    }
    @IBAction func maleAct(_ sender: UIButton)
    {
        self.selectedGender = "Male"
        self.male.backgroundColor = UIColor(red: 11/255.0, green: 200/255.0, blue: 180/255.0, alpha: 1)//UIColor(red: 35/255.0, green: 166/255.0, blue: 152/255.0, alpha: 1)
        self.femaleBtn.backgroundColor = UIColor.clear
        self.male.layer.cornerRadius = 6
        self.male.layer.borderWidth = 1
        self.male.layer.borderColor = UIColor(red: 193/255.0, green: 206/255.0, blue: 218/255.0, alpha: 1).cgColor
//        femaleLbl.textColor = UIColor(red: 0/255.0, green: 106/255.0, blue: 160/255.0, alpha: 1)
//        maleLbl.textColor = UIColor.white
        
        DEFAULT.set("Male", forKey: "GENDER")
               DEFAULT.synchronize()
        femaleLbl.textColor = UIColor(red: 79/255.0, green: 112/255.0, blue: 148/255.0, alpha: 1)
        maleLbl.textColor = UIColor(red: 231/255.0, green: 251/255.0, blue: 249/255.0, alpha: 1)
        
        
        maleImg.image = UIImage(named: "Path 111")
        femaleImg.image = UIImage(named: "Group 141")
        
    }
    
    
    
}
