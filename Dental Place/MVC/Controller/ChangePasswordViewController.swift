//
//  ChangePasswordViewController.swift
//  Dental Place
//
//  Created by AMARENDRA on 01/04/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController
{
    
    @IBOutlet weak var complete: UIButton!
    @IBOutlet weak var confirmpwdTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var oldPaswordTxt: UITextField!
    var registerData:RegisterModel?
    
    var userEmail=""
    var userOTP=""
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.complete.layer.cornerRadius = 6
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func completeAct(_ sender: UIButton)
    {
        if passwordTxt.text == ""
        {
            NetworkEngine.commonAlert(message: "Please enter password.", vc: self)
            
        }
       else if oldPaswordTxt.text == ""
        {
            NetworkEngine.commonAlert(message: "Please enter old password.", vc: self)
            
        }

        else if (Int(passwordTxt.text!.count) < 6)
        {
            NetworkEngine.commonAlert(message: "Please enter at least 6 characters password.", vc: self)
            
        }
            
        else if passwordTxt.text != confirmpwdTxt.text
        {
            NetworkEngine.commonAlert(message: "Password and confirm password should match.", vc: self)
            
        }
            
        else
        {
            
            if !(NetworkEngine.networkEngineObj.isInternetAvailable())
            {
                NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
            }
            else
            {
                self.ChangePasswordAPI()
            }
            
        }
    }
    
    @IBAction func loginGoing(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
//        let signup = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//        self.navigationController?.pushViewController(signup, animated: true)
//
        
    }
}
extension ChangePasswordViewController
{
    //MARK:- change password Api
    
    func ChangePasswordAPI()
    {
        
        
        let params =     ["current_password" :oldPaswordTxt.text!,
                          "new_password" : passwordTxt.text!,
                          "confirm_password" : confirmpwdTxt.text!]
            
            as [String : String]
        var apiKey = "1234"
        if let newuserEmail1 = DEFAULT.value(forKey: "APITOKEN") as? String
        {
            apiKey = "\(newuserEmail1)"
        }
        
        var DEVICETOKEN = "123456"
                       if let device = DEFAULT.value(forKey: "DEVICETOKEN") as? String
                       {
                           DEVICETOKEN = device
                       }
        let header = ["device-id":DEVICETOKEN,"device-type":"iOS","type":"iOS","api-token":apiKey] as [String:String]
        
        ApiHandler.ModelApiPostMethod(url: CHANGEPASSORDAPI, parameters: params, Header: header) { (response, error) in
            
            if error == nil
            {
                let decoder = JSONDecoder()
                do
                {
                    self.registerData = try decoder.decode(RegisterModel.self, from: response!)
                    if self.registerData?.statusCode == "200"
                        
                    {
                       
                        
                        self.view.makeToast(self.registerData?.message)
                       
                       
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0)
                        {
                    self.navigationController?.popViewController(animated: true)

                        };
                    }
                    else
                    {
                        NetworkEngine.commonAlert(message: self.registerData?.message ?? "", vc: self)
                        
                        //self.view.makeToast(self.registerData?.message)
                    }
                    
                    
                }
                catch let error
                {
                    self.view.makeToast(error.localizedDescription)
                }
                
            }
            else
            {
                self.view.makeToast(error)
            }
        }
    }
    
}
