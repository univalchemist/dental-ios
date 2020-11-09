//
//  ForgetPassView.swift
//  Dental Place
//
//  Created by eWeb on 11/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import UIKit

class ForgetPassView: UIViewController
{

    @IBOutlet weak var submit: UIButton!
    
    var registerData:ForgotModel?

    @IBOutlet weak var emailField: UITextField!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.submit.layer.cornerRadius = 6
        
    }
    
    @IBAction func gotoLogin(_ sender: UIButton)
    {
        let signup = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(signup, animated: true)
        
    }
    
    @IBAction func submit(_ sender: UIButton)
    {
//        let signup = self.storyboard?.instantiateViewController(withIdentifier: "OTPscreen") as! OTPscreen
//        self.navigationController?.pushViewController(signup, animated: true)
//
        if emailField.text == ""
        {
            
            NetworkEngine.commonAlert(message: "Please enter email id.", vc: self)
            
        }
        else if !NetworkEngine.networkEngineObj.validateEmail(candidate: emailField.text!)
        {
            NetworkEngine.commonAlert(message: "Please enter valid email.", vc: self)
        }
            
        else
        {
            
            if !(NetworkEngine.networkEngineObj.isInternetAvailable())
            {
                NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
            }
            else
            {
                self.ForgotAPI()
            }
            
        }
        
    }
}

extension ForgetPassView
{
    //MARK:- forgot Api
    
    func ForgotAPI()
    {
        var DEVICETOKEN = "123456"
        if let device = DEFAULT.value(forKey: "DEVICETOKEN") as? String
                                       {
                                           DEVICETOKEN = device
                                       }
        let params = ["email" : emailField.text!]   as [String : String]
        let header = ["device-id":DEVICETOKEN,"device-type":"iOS"] as [String:String]
        
        ApiHandler.ModelApiPostMethod(url: RECOVERYPASSORDAPI, parameters: params, Header: header) { (response, error) in
            
            if error == nil
            {
                let decoder = JSONDecoder()
                do
                {
                    self.registerData = try decoder.decode(ForgotModel.self, from: response!)
                    if self.registerData?.code == 201
                        
                    {
                        
                        let alert = UIAlertController(title: "Alert!", message: self.registerData?.message, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                            
                            let OTPscreen = self.storyboard?.instantiateViewController(withIdentifier: "OTPscreen") as! OTPscreen
                            OTPscreen.userOTP=self.registerData?.otp ?? ""
                           OTPscreen.userEmail=self.emailField.text!
                            self.navigationController?.pushViewController(OTPscreen, animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                        

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
                    print(error)
                }
                
            }
            else
            {
                print(error)
                self.view.makeToast(error)
            }
        }
    }
    
}
