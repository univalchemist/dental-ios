//
//  wecomeScreenOne.swift
//  Dental Place
//
//  Created by eWeb on 11/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit

class wecomeScreenOne: UIViewController,UITextFieldDelegate
{

    @IBOutlet weak var nxt: UIButton!
    @IBOutlet weak var skip: UIButton!
    
    
    @IBOutlet weak var lastnameTxt: UITextField!
    @IBOutlet weak var firstnameTxt: UITextField!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.nxt.layer.cornerRadius = 6
        self.skip.layer.cornerRadius = 6
        self.skip.layer.borderWidth = 1
        self.skip.layer.borderColor = UIColor(red: 35/255.0, green: 166/255.0, blue: 152/255.0, alpha: 1).cgColor
        lastnameTxt.delegate = self
               firstnameTxt.delegate = self
        
        if DEFAULT.value(forKey: "first_name") != nil
        {
          self.firstnameTxt.text = DEFAULT.value(forKey: "first_name") as? String
        }
        if DEFAULT.value(forKey: "last_name") != nil
        {
            self.lastnameTxt.text = DEFAULT.value(forKey: "last_name") as? String
        }
        
        
        
    }
    
    @IBAction func newxtAct(_ sender: UIButton)
    {
        
        if firstnameTxt.text == ""
        {
            
            NetworkEngine.commonAlert(message: "Please enter first name.", vc: self)
            
        }
        else if lastnameTxt.text == ""
        {
            NetworkEngine.commonAlert(message: "Please enter last name.", vc: self)
            
        }
        else
        {
let wscreen2 = self.storyboard?.instantiateViewController(withIdentifier: "wscreen2") as! wscreen2
wscreen2.firstName = self.firstnameTxt.text!
wscreen2.lastName = self.lastnameTxt.text!
            
            let username = self.firstnameTxt.text! + " " + self.lastnameTxt.text!
            
            DEFAULT.set(username, forKey: "USERNAME")
            DEFAULT.synchronize()
            

    self.navigationController?.pushViewController(wscreen2, animated: true)
        }
    
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let maxLength = 30
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    @IBAction func skipAct(_ sender: UIButton)
    {
        let wscreen2 = self.storyboard?.instantiateViewController(withIdentifier: "wscreen2") as! wscreen2
        self.navigationController?.pushViewController(wscreen2, animated: true)
        
        
    }
    
}
