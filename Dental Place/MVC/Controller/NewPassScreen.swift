//
//  NewPassScreen.swift
//  Dental Place
//
//  Created by eWeb on 11/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit

class NewPassScreen: UIViewController
{

    @IBOutlet weak var complete: UIButton!
    @IBOutlet weak var confirmpwdTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    var registerData:ForgotModel?
    
    var userEmail=""
    var userOTP=""

    
    override func viewDidLoad()
    {
        super.viewDidLoad()

      self.complete.layer.cornerRadius = 6
        
    }
 
    @IBAction func completeAct(_ sender: UIButton)
    {
         if passwordTxt.text == ""
        {
            NetworkEngine.commonAlert(message: "Please enter password.", vc: self)
            
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
        let signup = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(signup, animated: true)
        
        
    }
}
extension NewPassScreen
{
    //MARK:- change password Api
    
    func ChangePasswordAPI()
    {
        
        
    let params =     ["email" : self.userEmail,
                      "otp" : self.userOTP,
                      "password" : passwordTxt.text!,
                      "password_confirmation" : confirmpwdTxt.text!]
        as [String : String]
        var DEVICETOKEN = "123456"
        if let device = DEFAULT.value(forKey: "DEVICETOKEN") as? String
        {
            DEVICETOKEN = device
        }
        
        let header = ["device-id":DEVICETOKEN,"device-type":"iOS"] as [String:String]
        
        ApiHandler.ModelApiPostMethod(url: UPDATEPASSORDAPI, parameters: params, Header: header) { (response, error) in
            
            if error == nil
            {
                let decoder = JSONDecoder()
                do
                {
                    self.registerData = try decoder.decode(ForgotModel.self, from: response!)
                    if self.registerData?.code == 201
                        
                    {
                        self.view.makeToast(self.registerData?.message)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
                        {
                            APPDEL.loadLoginView()
                        }
                        
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
